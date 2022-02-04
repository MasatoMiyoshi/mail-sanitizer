module Mail
  module Sanitizer
    class Sanitizer
      attr_reader :sanitized_body
      attr_reader :quot
      attr_reader :sign

      def initialize(body)
        @src = body.dup
        @src = @src.encode('utf-8', invalid: :replace, undef: :replace) unless @src.nil?
        @sanitized_body = nil
        @quot = nil
        @sign = nil
      end

      def sanitize
        @sanitized_body, @quot, @sign = delete_quot_sign(@src)
        @sanitized_body
      end

      private

      def delete_quot_sign(str)
        return nil, nil, nil if str.nil?

        lines = Mail::Sanitizer::String.split_line(str.strip)
        quot_lines = []
        sign_lines = []

        blocks = split_block(lines.join("\n").strip)
        case blocks.last[:type]
        when :quot
          quot_lines += lines.slice!(blocks.last[:start]..blocks.last[:end])
          if blocks.size > 1 && blocks[-2][:type] == :sign
            sign_lines += lines.slice!(blocks[-2][:start]..blocks[-2][:end])
          end
        when :sign
          sign_lines += lines.slice!(blocks.last[:start]..blocks.last[:end])
          if blocks.size > 1 && blocks[-2][:type] == :quot
            quot_lines += lines.slice!(blocks[-2][:start]..blocks[-2][:end])
          end
        end

        return lines.join("\n").strip, quot_lines.join("\n").strip, sign_lines.join("\n").strip
      end

      def split_block(str)
        lines = Mail::Sanitizer::String.split_line(str)
        numrow = lines.size

        line_types = Array.new(numrow, :normal)
        sign_index = nil
        look_sign_symbol = false
        lines.each_with_index.reverse_each do |line, i|
          if line =~ Mail::Sanitizer::Constant::QUOT_SYMBOL_PATTERN
            line_types[i] = :quot
          elsif line =~ Mail::Sanitizer::Constant::SIGN_PATTERN
            if sign_index.nil?
              sign_index = i
            else
              line_types[i, sign_index - i + 1] = Array.new(sign_index - i + 1, :sign)
              sign_index = nil
            end
          elsif line =~ Mail::Sanitizer::Constant::SIGN_SYMBOL_PATTERN
            next if look_sign_symbol
            if line_types[i..-1].include?(:quot)
              j = line_types[i..-1].index(:quot)
            else
              j = numrow - i
            end
            line_types[i, j] = Array.new(j, :sign)
            look_sign_symbol = true
          elsif line =~ /^[[:space:]]*$/
            line_types[i] = nil
          end
        end

        lines.each_with_index do |line, i|
          keywords = {}
          Mail::Sanitizer::Constant::QUOT_KEYWORD_SET.each do |set|
            keywords.clear
            sidx = 0
            set.each do |key|
              keywords[key] = false
              while (i + sidx) < numrow do
                downcased_line = Mail::Sanitizer::String.downcase(lines[i + sidx])
                unless downcased_line.empty?
                  keywords[key] = true if downcased_line =~ /^#{key}/
                  sidx += 1
                  break
                end
                sidx += 1
              end
              break unless keywords[key]
            end
            break if keywords.values.all?
          end

          if keywords.values.all? ||
             Mail::Sanitizer::String.quot_pattern?(line) ||
             Mail::Sanitizer::String.include_datetime_and_email_address?(line)
            line_types[i, numrow - i] = Array.new(numrow - i, :quot) unless line_types[i] == :quot
            break
          end
        end

        concat_line_types(line_types)
      end

      def concat_line_types(line_types)
        blocks = []
        s_pos  = 0
        pre_line_type = nil

        line_types.each_with_index do |line_type, i|
          unless line_type == pre_line_type
            unless pre_line_type.nil?
              if !blocks.empty? && blocks.last[:type] == pre_line_type
                blocks.last[:end] = i - 1
              else
                blocks << { type: pre_line_type, start: s_pos, end: i - 1 }
              end
            end
            s_pos = i
          end
          pre_line_type = line_type
        end

        if !blocks.empty? && blocks.last[:type] == pre_line_type
          blocks.last[:end] = line_types.size - 1
        else
          blocks << { type: pre_line_type, start: s_pos, end: line_types.size - 1 }
        end
        blocks
      end
    end
  end
end
