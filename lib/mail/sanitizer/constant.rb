module Mail
  module Sanitizer
    class Constant
      QUOT_SYMBOL_PATTERN = /^>/
      QUOT_PATTERN = /wrote:|-originalmessage-|-forwardedmessage-/
      QUOT_DATETIME_PATTERN = /^(on|at)/
      SIGN_SYMBOL_PATTERN = /^--[ ]*$/
      SIGN_PATTERN = /^[^[[:alnum:]]|\p{Hiragana}|\p{Katakana}|[一-龠々]]{5,}$/
    end
  end
end
