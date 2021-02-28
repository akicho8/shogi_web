# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Article (wkbk_articles as Wkbk::Article)
#
# |---------------------+---------------------+-------------+---------------------+--------------+-------|
# | name                | desc                | type        | opts                | refs         | index |
# |---------------------+---------------------+-------------+---------------------+--------------+-------|
# | id                  | ID                  | integer(8)  | NOT NULL PK         |              |       |
# | key                 | ユニークなハッシュ  | string(255) | NOT NULL            |              | A!    |
# | user_id             | User                | integer(8)  | NOT NULL            | => ::User#id | B     |
# | folder_id           | Folder              | integer(8)  | NOT NULL            |              | C     |
# | lineage_id          | Lineage             | integer(8)  | NOT NULL            |              | D     |
# | init_sfen           | Init sfen           | string(255) | NOT NULL            |              | E     |
# | viewpoint           | Viewpoint           | string(255) | NOT NULL            |              |       |
# | title               | タイトル            | string(100) | NOT NULL            |              |       |
# | description         | 説明                | text(65535) | NOT NULL            |              |       |
# | direction_message   | Direction message   | string(100) | NOT NULL            |              |       |
# | turn_max            | 手数                | integer(4)  | NOT NULL            |              | F     |
# | mate_skip           | Mate skip           | boolean     | NOT NULL            |              |       |
# | moves_answers_count | Moves answers count | integer(4)  | DEFAULT(0) NOT NULL |              |       |
# | difficulty          | Difficulty          | integer(4)  | NOT NULL            |              | G     |
# | answer_logs_count   | Answer logs count   | integer(4)  | DEFAULT(0) NOT NULL |              |       |
# | created_at          | 作成日時            | datetime    | NOT NULL            |              |       |
# | updated_at          | 更新日時            | datetime    | NOT NULL            |              |       |
# |---------------------+---------------------+-------------+---------------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module Wkbk
  class Article < ApplicationRecord
    include FolderMethods
    include ImportExportMethods
    include InfoMethods
    include JsonStruct

    belongs_to :user, class_name: "::User"                                                      # 作者
    belongs_to :lineage                                                                         # 種類
    has_many :moves_answers, -> { order(:position) }, dependent: :destroy, inverse_of: :article # 解答たち

    acts_as_taggable

    attribute :moves_answer_validate_skip

    before_validation do
      # if book
      #   self.user ||= book.user
      # end

      if Rails.env.development? || Rails.env.test?
        self.title ||= SecureRandom.hex
        self.init_sfen ||= "position sfen 7nl/7k1/9/7pp/6N2/9/9/9/9 b GS2r2b3g3s2n3l16p 1"
      end

      if Rails.env.test?
        self.title ||= "(title#{self.class.count.next})"
      end

      self.viewpoint ||= "black"
      self.lineage_key ||= "次の一手"
      self.key ||= secure_random_urlsafe_base64_token
      self.difficulty ||= 1
      self.turn_max ||= 0
      self.folder_key ||= :public

      # if lineage.pure_info.mate_validate_on
      #   self.mate_skip ||= false
      # else
      #   self.mate_skip = nil
      # end
      self.mate_skip ||= false

      normalize_zenkaku_to_hankaku(:title, :description, :direction_message)
      normalize_blank_to_empty_string(:title, :description, :direction_message)
    end

    with_options presence: true do
      validates :title
      validates :init_sfen
      validates :viewpoint
    end

    with_options allow_blank: true do
      # validates :title, uniqueness: { scope: :user_id, case_sensitive: true, message: "が重複しています" }
      validates :title, length: { maximum: 100 }
      validates :description, length: { maximum: 5000 }
    end

    # validate do
    #   if changes_to_save[:book_keys] || changes_to_save[:user_id]
    #     if book && user
    #       if book.user != user
    #         errors.add(:base, "問題集の所有者と問題の所有者が異なります")
    #       end
    #     end
    #   end
    # end

    # validate do
    #   if false
    #     if changes_to_save[:book_keys] && book
    #       if book.folder_key == :public && folder_key === :private
    #         errors.add(:base, "公開している問題集に非公開の問題は入れられません")
    #       end
    #     end
    #   end
    # end

    def mock_attrs_set
      if Rails.env.test?
        self.init_sfen ||= "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l#{Article.count.next}p 1"
        if moves_answers.empty?
          moves_answers.build(moves_str: "G*5b")
        end
      end
    end

    # jsから来たパラメーターでまとめて更新する
    #
    #   params = {
    #     "title"            => "(title)",
    #     "init_sfen"        => "4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p 1",
    #     "moves_answers"    => [{"moves_str"=>"4c5b"}],
    #     "time_limit_clock" => "1999-12-31T15:03:00.000Z",
    #   }
    #   article = user.wkbk_articles.build
    #   article.update_from_js(params)
    #   article.moves_answers.collect{|e|e.moves_str} # => ["4c5b"]
    #
    def update_from_js(params)
      article = params.deep_symbolize_keys

      ActiveRecord::Base.transaction do
        attrs = article.slice(*[
                                :folder_key,
                                :init_sfen,
                                :viewpoint,
                                :title,
                                :description,
                                :direction_message,
                                :difficulty,
                                :mate_skip,
                                :tag_list,
                                :lineage_key,
                              ])

        assign_attributes(attrs)
        save!

        # bookships の更新
        self.book_keys = article[:book_keys]

        # moves_answers の更新
        begin
          records = article[:moves_answers]
          # 削除
          # [1, 2, 3] があるとき [1, 3] をセットすることで [2] が削除される
          self.moves_answer_ids = records.collect { |e| e[:id] }
          # 追加 or 更新
          records.each do |e|
            if v = e[:id]
              moves_answer = moves_answers.find(v)
            else
              moves_answer = moves_answers.build
            end

            moves_answer.moves_str = e[:moves_str]
            # moves_answer.end_sfen = e[:end_sfen]
            moves_answer.save!
          end
        end
      end

      developer_notice
    end

    def developer_notice
      str = created_at == updated_at ? "作成" : "更新"
      SlackAgent.message_send(key: "問題#{str}", body: [title, page_url].join(" "))
      subject = "#{user.name}さんが問題「#{title}」を#{str}"
      body = info.collect { |k, v| "#{k}: #{v}\n" }.join
      ApplicationMailer.developer_notice(subject: subject, body: body).deliver_later
    end

    def book_keys=(v)
      if new_record?
        warn "article をDBに保存していないタイミングでは bookships も保存できていない"
      end
      self.books = Book.where(key: v) # persisted? なら INSERT が走る
    end

    def book_keys
      books.collect(&:key) # 保存しているとは限らないため pluck したらいけない
    end

    def init_sfen=(sfen)
      write_attribute(:init_sfen, sfen.to_s.remove(/\s*position\s+sfen\s*/).presence)
    end

    def init_sfen
      if sfen = read_attribute(:init_sfen)
        "position sfen #{sfen}"
      end
    end

    def lineage_key
      if lineage
        lineage.key
      end
    end

    def lineage_key=(key)
      self.lineage = Lineage.fetch_if(key)
    end

    def linked_title(options = {})
      ApplicationController.helpers.link_to(title, page_url(only_path: true))
    end

    def og_image_path
      if persisted?
        v = {}
        v[:turn]               = 0
        v[:body]               = init_sfen
        v[:abstract_viewpoint] = viewpoint
        "/share-board.png?#{v.to_query}"
      end
    end

    def og_meta
      if new_record?
        {
          :title       => "新規 - 問題",
          :description => "",
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

    def default_assign
      # "position sfen 4k4/9/9/9/9/9/9/9/9 b 2r2b4g4s4n4l18p 1"

      # self.folder_key     ||= :public
      self.init_sfen      ||= "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1"
      self.viewpoint      ||= "black"
      self.mate_skip      ||= false
      self.difficulty     ||= 1
      self.tag_list ||= []

      if Rails.env.development?
        self.init_sfen = "position sfen 7nl/7k1/9/7pp/6N2/9/9/9/9 b GS2r2b3g3s2n3l16p 1"
        self.moves_answers.build(moves_str: "S*2c 2b3c G*4c")
        self.moves_answers.build(moves_str: "S*2c 2b1c 2c1b+ 1c1b G*2c")
        self.moves_answers.build(moves_str: "S*2c 2b1c 2c1b+ 1a1b G*2c")
        self.moves_answers.build(moves_str: "S*2c 2b3a G*3b")
      end
    end

    private

    concerning :BookshipMethods do
      included do
        has_many :bookships, dependent: :destroy, inverse_of: :article, autosave: true # 問題集と問題の中間情報たち
        has_many :books, through: :bookships                           # 自分が入っている問題集たち

        # 問題集に追加している問題を更新すると問題集たちの更新日時を更新する
        after_save do
          books.each do |e|
            e.update!(updated_at: Time.now)
          end
        end
      end
    end

    concerning :AnswerLogMethods do
      included do
        has_many :answer_logs, dependent: :destroy, inverse_of: :article
        has_many :answered_answer_kinds, through: :answer_logs, source: :answer_kind
        has_many :answered_books, through: :answer_logs, source: :book
        has_many :answered_users, through: :answer_logs, source: :user
      end
    end
  end
end
