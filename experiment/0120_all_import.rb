#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

ActsAsTaggableOn::Tag.destroy_all
ActsAsTaggableOn::Tagging.destroy_all
General::Battle.all_import(limit: 10, reset: true)

tp General::User

tp General::Battle.all.collect {|e| e.other_tag_list.join(",") }
# >> ["2018-02-28 00:03:34", "begin", 0, 0]
# >> CCCCC
# >> ["2018-02-28 00:03:36", "end__", 10, 5]
# >> |----+------------+---------------------------+---------------------------|
# >> | id | name       | created_at                | updated_at                |
# >> |----+------------+---------------------------+---------------------------|
# >> | 11 | 一太郎     | 2018-02-28 00:03:35 +0900 | 2018-02-28 00:03:35 +0900 |
# >> | 12 | 二太郎     | 2018-02-28 00:03:35 +0900 | 2018-02-28 00:03:35 +0900 |
# >> | 13 | 三太郎     | 2018-02-28 00:03:35 +0900 | 2018-02-28 00:03:35 +0900 |
# >> | 14 | 四太郎     | 2018-02-28 00:03:35 +0900 | 2018-02-28 00:03:35 +0900 |
# >> | 15 | 花村元司   | 2018-02-28 00:03:35 +0900 | 2018-02-28 00:03:35 +0900 |
# >> | 16 | 阿久津主税 | 2018-02-28 00:03:35 +0900 | 2018-02-28 00:03:35 +0900 |
# >> | 17 | 木村秀利   | 2018-02-28 00:03:36 +0900 | 2018-02-28 00:03:36 +0900 |
# >> | 18 | 中村亮介   | 2018-02-28 00:03:36 +0900 | 2018-02-28 00:03:36 +0900 |
# >> | 19 | 森内俊之   | 2018-02-28 00:03:36 +0900 | 2018-02-28 00:03:36 +0900 |
# >> | 20 | 阿部光瑠   | 2018-02-28 00:03:36 +0900 | 2018-02-28 00:03:36 +0900 |
# >> |----+------------+---------------------------+---------------------------|
# >> |------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> | その他の棋戦,15分,女流,棋士の日リレー対局,まつり,一太郎,五段,二太郎,四段,三太郎,四太郎,王将,東京,将棋会館,1989,0,1,平手,投了,00001                                     |
# >> | 朝日オープン,3時間,第20回,朝日,オープン,将棋,選手権,本戦,1回戦,反則,二歩,▲中飛車穴熊5筋位取り,一太郎,東地区,代表,二太郎,西地区,東京,将棋会館,87,平手,00002            |
# >> | その他の棋戦,2時間,東西対抗フレッシュ勝ち抜き戦第8戦,将棋,世界,2010年,4月号,花村元司,五段,阿久津主税,七段,東京,将棋会館,2050,1,31,2050/01,2050/01/31,6,平手,投了,00003 |
# >> | 近将カップ,30分＋1分,第2回,1回戦,第17局,千日手局,木村秀利,アマ,中村亮介,三段,近将道場特別対局室,2004,3,20,2004/03,2004/03/20,59,平手,千日手,00004                      |
# >> | 棋聖戦,各3時間,森内俊之,九段,阿部光瑠,六段,東京将棋会館,2017,2,21,2017/02,2017/02/21,79,平手,投了,00005                                                                |
# >> |------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
