require 'rails_helper'

# spec/models/acns2/elo_rating_spec.rb
# experiment/elo_rating.rb
module Acns2
  RSpec.describe EloRating, type: :model do
    def test(n, a, b)
      x, y = Acns2::EloRating.public_send("rating_update#{n}", a, b)
      [x - a, y - b].collect { |e| e.round(2) }
    rescue => error
      error.message
    end

    it do
      assert { test(1, 1500, 1899) == [29.08, -29.08] }
      assert { test(1, 1500, 1900) == [29.09, -29.09] }
      assert { test(1, 1500, 1901) == [29.11, -29.11] }
      assert { test(1, 1500, 9999) == [32.0, -32.0]   }
      assert { test(1, 1899, 1500) == [2.92, -2.92]   }
      assert { test(1, 1900, 1500) == [2.91, -2.91]   }
      assert { test(1, 1901, 1500) == [2.89, -2.89]   }
      assert { test(1, 9999, 1500) == [0.0, 0.0]      }

      assert { test(2, 1500, 1899) == [29.08, -29.08] }
      assert { test(2, 1500, 1900) == [29.09, -29.09] }
      assert { test(2, 1500, 1901) == [29.11, -29.11] }
      assert { test(2, 1500, 9999) == [32.0, -32.0]   }
      assert { test(2, 1899, 1500) == [2.92, -2.92]   }
      assert { test(2, 1900, 1500) == [2.91, -2.91]   }
      assert { test(2, 1901, 1500) == [2.89, -2.89]   }
      assert { test(2, 9999, 1500) == [1, -1]         }

      assert { test(3, 1500, 1899) == [31.96, -31.96]                                                    }
      assert { test(3, 1500, 1900) == [32.0, -32.0]                                                      }
      assert { test(3, 1500, 1901) == "R差401 > 400 のとき加算値32.04が32を超える"                       }
      assert { test(3, 1500, 9999) == "R差8499 > 400 のとき加算値355.96が32を超える"                     }
      assert { test(3, 1899, 1500) == [0.04, -0.04]                                                      }
      assert { test(3, 1900, 1500) == "R差-400 == -400 のとき加算値0.0が0になる"                         }
      assert { test(3, 1901, 1500) == "R差-401 < -400 のとき加算値-0.03999999999999915がマイナスになる"  }
      assert { test(3, 9999, 1500) == "R差-8499 < -400 のとき加算値-323.96がマイナスになる"              }

      assert { test(4, 1500, 1899) == [31.96, -31.96] }
      assert { test(4, 1500, 1900) == [32.0, -32.0]   }
      assert { test(4, 1500, 1901) == [32, -32]       }
      assert { test(4, 1500, 9999) == [32, -32]       }
      assert { test(4, 1899, 1500) == [1, -1]         }
      assert { test(4, 1900, 1500) == [1, -1]         }
      assert { test(4, 1901, 1500) == [1, -1]         }
      assert { test(4, 9999, 1500) == [1, -1]         }
    end
  end
end

