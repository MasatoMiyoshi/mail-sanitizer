module Mail
  module Sanitizer
    class String
      ADDRESS_REGEXP = /([a-zA-Z0-9_!#$%&`'"*+\-{|}~^\/=?\.]+@[a-zA-Z0-9][a-zA-Z0-9\.\-]+)/
      SP    = "[[:space:]]"
      DIGIT = "[0-9０-９]"
      YEAR  = "(#{DIGIT}{4})#{SP}*年"
      MONTH = "(#{DIGIT}{1,2})#{SP}*月"
      DAY   = "(#{DIGIT}{1,2})#{SP}*日"
      HOUR  = "(#{DIGIT}+)#{SP}*時"
      MIN   = "(#{DIGIT}+)#{SP}*分"

      PATTERNS = [
        [/#{YEAR}#{MONTH}#{DAY}/, '\1/\2/\3'],
        [/#{HOUR}#{MIN}/, '\1:\2']
      ]

      class << self
        def split_line(str)
          str.split(/\r\n|\r|\n/)
        end

        def downcase(str)
          str.downcase.gsub(/[[:space:]]/, '')
        end

        def quot_pattern?(str)
          s = downcase(str)
          (s =~ Mail::Sanitizer::Constant::QUOT_PATTERN) ||
          (s =~ Mail::Sanitizer::Constant::QUOT_DATETIME_PATTERN && Mail::Sanitizer::String.include_datetime?(str))
        end

        def include_datetime_and_email_address?(str)
          s = Mail::Sanitizer::String.remove_email_address(str)
          Mail::Sanitizer::String.include_email_address?(str) && Mail::Sanitizer::String.include_datetime?(s)
        end

        def include_datetime?(str)
          str = replace_jp_datetime(str)
          DateTime.parse(str)
          true
        rescue
          false
        end

        def include_email_address?(str)
          ADDRESS_REGEXP.match?(str)
        end

        def remove_email_address(str)
          str.gsub(ADDRESS_REGEXP, '')
        end

        def replace_jp_datetime(str)
          return nil if str.nil? || str == ''
          fstr = str.dup
          PATTERNS.each { |pattern| fstr.gsub!(pattern[0], pattern[1]) }
          fstr
        end
      end
    end
  end
end
