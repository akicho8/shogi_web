# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Book (wkbk_books as Wkbk::Book)
#
# |-------------------+--------------------+-------------+---------------------+--------------+-------|
# | name              | desc               | type        | opts                | refs         | index |
# |-------------------+--------------------+-------------+---------------------+--------------+-------|
# | id                | ID                 | integer(8)  | NOT NULL PK         |              |       |
# | key               | ユニークなハッシュ | string(255) | NOT NULL            |              | A!    |
# | user_id           | User               | integer(8)  | NOT NULL            | => ::User#id | B     |
# | folder_id         | Folder             | integer(8)  | NOT NULL            |              | C     |
# | sequence_id       | Sequence           | integer(8)  | NOT NULL            |              | D     |
# | title             | タイトル           | string(100) | NOT NULL            |              |       |
# | description       | 説明               | text(65535) | NOT NULL            |              |       |
# | bookships_count   | Bookships count    | integer(4)  | DEFAULT(0) NOT NULL |              |       |
# | answer_logs_count | Answer logs count  | integer(4)  | DEFAULT(0) NOT NULL |              |       |
# | created_at        | 作成日時           | datetime    | NOT NULL            |              |       |
# | updated_at        | 更新日時           | datetime    | NOT NULL            |              |       |
# |-------------------+--------------------+-------------+---------------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require "nkf"

module Wkbk
  class Book < ApplicationRecord
    include FolderMethods
    include InfoMethods
    include AvatarMethods
    include JsonStruct
    include MockMethods

    belongs_to :user, class_name: "::User"

    acts_as_taggable

    scope :search, -> params {
      base = all.joins(:folder, :user)
      s = base
      if v = params[:tag].to_s.split(/[,\s]+/).presence
        s = s.where(id: tagged_with(v))
      end
      if v = params[:query].presence
        v = [
          v,
          NKF.nkf("-w --hiragana", v),
          NKF.nkf("-w --katakana", v),
        ].uniq.collect { |e| "%#{e}%" }
        s = s.where(arel_table[:title].matches_any(v))
        s = s.or(base.where(arel_table[:description].matches_any(v)))
        s = s.or(base.where(User.arel_table[:name].matches_any(v)))
      end
      # SELECT wkbk_books.* FROM wkbk_books INNER JOIN wkbk_folders ON wkbk_folders.id = wkbk_books.folder_id INNER JOIN users ON users.id = wkbk_books.user_id WHERE (title LIKE '%a%' OR description LIKE '%a%')"
      # SELECT wkbk_books.* FROM wkbk_books INNER JOIN wkbk_folders ON wkbk_folders.id = wkbk_books.folder_id INNER JOIN users ON users.id = wkbk_books.user_id WHERE ((title LIKE '%a%' OR description LIKE '%a%') OR users.name LIKE '%a%')"
      # SELECT wkbk_books.* FROM wkbk_books INNER JOIN wkbk_folders ON wkbk_folders.id = wkbk_books.folder_id INNER JOIN users ON users.id = wkbk_books.user_id WHERE (((title LIKE '%%a%%') OR (description LIKE '%%a%%')) OR users.name LIKE '%a%')"
      s
    }

    before_validation do
      self.folder_key ||= :private
      self.sequence_key ||= :bookship_shuffle
      self.key ||= secure_random_urlsafe_base64_token

      if Rails.env.test? || Rails.env.development?
        self.title       ||= key
        self.description ||= "(description)"
      end

      normalize_zenkaku_to_hankaku(:title, :description)
      normalize_blank_to_empty_string(:title, :description)
    end

    with_options presence: true do
      validates :title
    end

    with_options allow_blank: true do
      validates :title, uniqueness: { scope: :user_id, case_sensitive: true, message: "が重複しています" }
      validates :title, length: { maximum: 100 }
      validates :description, length: { maximum: 5000 }
    end

    def page_url(options = {})
      UrlProxy.wrap2("/rack/books/#{key}")
    end

    # jsから来たパラメーターでまとめて更新する
    #
    #   params = {
    #     "title"            => "(title)",
    #     "init_sfen"        => "4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p 1",
    #     "moves_answers"    => [{"moves_str"=>"4c5b"}],
    #   }
    #   book = user.wkbk_books.build
    #   book.update_from_js(params)
    #   book.moves_answers.collect{|e|e.moves_str} # => ["4c5b"]
    #
    def update_from_js(params)
      book = params.deep_symbolize_keys
      old_new_record = new_record?

      ActiveRecord::Base.transaction do
        attrs = book.slice(*[
                             :title,
                             :description,
                             :folder_key,
                             :sequence_key,
                             :new_file_src,    # nil 以外が来たらそれで画像作成
                             :raw_avatar_path, # nil が来たら画像削除
                             :tag_list,
                           ])
        assign_attributes(attrs)
        save!

        ids = book[:ordered_bookships].collect { |e| e.fetch(:id) }
        bookships_order_by_ids(ids)
      end

      simple_track
    end

    def simple_track
      str = created_at == updated_at ? "作成" : "更新"
      SlackAgent.message_send(key: "問題集#{str}", body: [title, page_url].join(" "))
      subject = "#{user.name}さんが問題集「#{title}」を#{str}"
      body = info.collect { |k, v| "#{k}: #{v}\n" }.join
      SystemMailer.simple_track(subject: subject, body: body).deliver_later
    end

    # articles の並び替え
    #
    #   user = User.create!
    #   book = user.wkbk_books.create!
    #   book.articles << user.wkbk_articles.create!(key: "a")
    #   book.articles << user.wkbk_articles.create!(key: "b")
    #
    #   book.articles.order(:position).pluck(:key) # => ["a", "b"]
    #   book.bookships_order_by_ids(["b", "a"])
    #   book.articles.order(:position).pluck(:key) # => ["b", "a"]
    #
    # 次の方法の方がわかりやすいかもしれないけどSQLがさらに articles.count 回発生する
    #
    #   Bookship.acts_as_list_no_update do
    #     keys.each.with_index do |key, i|
    #       bookship = book.bookships.joins(:article).find_by!(Article.arel_table[:key].eq(key))
    #       bookship.position = i
    #       bookship.save!(validate: false, touch: false)
    #     end
    #   end
    #
    def bookships_order_by_ids(ids)
      table = bookships.inject({}) {|a, e| a.merge(e.id => e) }
      Bookship.acts_as_list_no_update do
        ids.each.with_index do |id, i|
          e = table.fetch(id)
          e.position = i
          e.save!(validate: false, touch: false)
        end
      end
    end

    def og_image_path
      avatar_path
    end

    def og_meta
      if new_record?
        {
          :title       => "新規 - 問題集",
          :description => description || "",
          :og_image    => "rack-books",
        }
      else
        {
          :title       => [title, user.name].join(" - "),
          :description => description || "",
          :og_image    => og_image_path || "rack-books",
        }
      end
    end

    def tweet_body
      list = [
        title,
        *tag_list,
        "インスタント将棋問題集",
      ]
      list.collect { |e| "#" + e.gsub(/[\p{blank}-]+/, "_") }.join(" ")
    end

    def default_assign
      # この2つは localStorage から復帰する
      # self.folder_key ||= :public
      # self.sequence_key ||= :bookship_shuffle

      if Rails.env.development?
        if user
          self.title ||= "#{user.name}のインスタント将棋問題集第#{user.wkbk_books.count.next}弾(仮)"
        end
        self.title       ||= "あ" * 80
        self.description ||= "い" * 256
      end

      self.title       ||= ""
      self.description ||= ""
      self.tag_list    ||= []
    end

    private

    # 公開した直後か？
    def public_folder_posted?
      saved_change_to_attribute?(:folder_id) && folder_eq(:public)
    end

    # 変更を検知するためのハッシュ(重要なデータだけにする)
    def current_hash
      ary = [
        title,
        description,
        bookships_count,
      ]
      Digest::MD5.hexdigest(ary.join(":"))
    end

    concerning :SequenceMethods do
      included do
        belongs_to :sequence
      end

      def sequence_key_eq(key)
        sequence_key.to_s == key.to_s
      end

      def sequence_key
        sequence&.key
      end

      def sequence_key=(key)
        self.sequence = Sequence.fetch(key)
      end

      def to_xitems(current_user)
        XitemsBuilder.new(current_user: current_user, book: self).to_a
      end
    end

    concerning :BookshipMethods do
      included do
        has_many :bookships, dependent: :destroy, inverse_of: :book do # 問題集と問題の中間情報たち
          def access_restriction_by(current_user)
            s = all
            if proxy_association.owner.user != current_user
              s = s.merge(Article.public_or_limited)
            end
            s
          end
        end

        has_many :articles, through: :bookships  # 自分に入っている問題たち

        has_many :ordered_bookships, -> { order(:position) }, dependent: :destroy, class_name: "Bookship" # 一発でjsonにしたいため

        attribute :current_user
      end

      # bookの下にあるものを全削除(超危険)
      # 中間情報経由で articles.destroy_all は空振りする(articles は削除されない)
      def dependent_records_destroy_all
        articles.each(&:destroy!)
        bookships.destroy_all
      end

      # アクセス可能な問題の数
      # current_user を考慮して決まるため book.as_json では出せない
      # なので筋悪だけどあらかじめ current_user を設定してから book.as_json する
      def bookships_count_by_current_user
        bookships.joins(:article).access_restriction_by(current_user).count
      end
    end

    concerning :AnswerLogMethods do
      included do
        has_many :answer_logs, dependent: :destroy, inverse_of: :book
        has_many :answered_answer_kinds, through: :answer_logs, source: :answer_kind
        has_many :answered_articles, through: :answer_logs, source: :article
        has_many :answered_users,    through: :answer_logs, source: :user
      end
    end

    concerning :ZipDownloadMethods do
      def to_send_data_params(params)
        BookArchive.new(params.merge(book: self)).to_send_data_params
      end
    end
  end
end
