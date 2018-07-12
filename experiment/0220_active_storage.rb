#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

tp ActiveStorage::Attachment
tp ActiveStorage::Blob
# >> |----+--------+-------------+-----------+---------+---------------------------|
# >> | id | name   | record_type | record_id | blob_id | created_at                |
# >> |----+--------+-------------+-----------+---------+---------------------------|
# >> |  3 | avatar | Fanta::User |        17 |       3 | 2018-07-12 17:50:55 +0900 |
# >> |----+--------+-------------+-----------+---------+---------------------------|
# >> |----+--------------------------+-----------+--------------+---------------------------------------------------------------------+-----------+--------------------------+---------------------------|
# >> | id | key                      | filename  | content_type | metadata                                                            | byte_size | checksum                 | created_at                |
# >> |----+--------------------------+-----------+--------------+---------------------------------------------------------------------+-----------+--------------------------+---------------------------|
# >> |  3 | NifSTS8yMwbH2jdSWsmQKV2X | photo.jpg | image/jpeg   | {"identified"=>true, "width"=>180, "height"=>180, "analyzed"=>true} |      9834 | sDGiVDTmmyIYyGl7BdhoTA== | 2018-07-12 17:50:55 +0900 |
# >> |----+--------------------------+-----------+--------------+---------------------------------------------------------------------+-----------+--------------------------+---------------------------|
