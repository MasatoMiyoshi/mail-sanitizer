module Mail
  module Sanitizer
    class Constant
      QUOT_SYMBOL_PATTERN = /^>/
      QUOT_PATTERN = /wrote:|-originalmessage-|-forwardedmessage-|forwardedby/
      QUOT_DATETIME_PATTERN = /^(on|at)/
      QUOT_KEYWORD_SET = [
        ['from:', 'sent:', 'to:', 'subject:'],
        ['差出人:', '送信日時:', '宛先:', '件名:']
      ]
      SIGN_SYMBOL_PATTERN = /^--[ ]*$/
      SIGN_PATTERN = /^[^[[:alnum:]]|\p{Hiragana}|\p{Katakana}|[一-龠々]]{5,}$/
    end
  end
end
