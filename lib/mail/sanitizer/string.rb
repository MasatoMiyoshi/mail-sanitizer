module Mail
  module Sanitizer
    class String
      ADDRESS_REGEXP = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
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
          str.split(/[\r\n]/)
        end

        def downcase(str)
          str.downcase.gsub(/[[:space:]]/, '')
        end

        def include_datetime?(str)
          str = replace_jp_datetime(str)
          DateTime.parse(str)
          true
        rescue
          false
        end

        def include_email_address?(str)
          texts = str.split(/#{SP}/)
          texts.each do |text|
            text.strip!
            text.gsub!(/^\(|^<|[^[:alpha:]]*$/, '')
            return true if ADDRESS_REGEXP === text
          end
          return false
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
