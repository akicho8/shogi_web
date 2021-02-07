import MemoryRecord from 'js-memory-record'

export class ArticleIndexColumnInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "key",            name: "KEY",      visible: false, togglable: true,  },
      { key: "title",          name: "タイトル", visible: null,  togglable: false, },
      // { key: "user_id",        name: "投稿",     visible: true,  togglable: false, },
      { key: "book_title",     name: "問題集",   visible: true,  togglable: true,  },
      { key: "lineage_key",    name: "種類",     visible: true,  togglable: true,  },
      { key: "turn_max",       name: "手数",     visible: true,  togglable: true,  },
      { key: "difficulty",     name: "難易度",   visible: true,  togglable: true,  },
      { key: "owner_tag_list", name: "タグ",     visible: true,  togglable: true,  },
      { key: "folder_key",     name: "公開設定", visible: true,  togglable: true,  },
      { key: "created_at",     name: "作成日時", visible: false, togglable: true,  },
      { key: "updated_at",     name: "更新日時", visible: true,  togglable: true,  },
    ]
  }
}
