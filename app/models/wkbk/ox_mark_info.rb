module Wkbk
  class OxMarkInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :correct, name: "正解",   },
      { key: :mistake, name: "不正解", },
    ]
  end
end
