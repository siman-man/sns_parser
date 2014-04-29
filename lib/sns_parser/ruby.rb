require 'pp'
require 'ripper'

class Ruby
  PINK = ["class","def"].freeze
  CONDITION = ["if","else"].freeze
  ORANGE = ["if"].freeze

  class << self
    def parse(file)
      self.new.run(file)
    end
  end

  def init
    @line_num = 1
    @kw_stack = []
    @def_flag = false
  end

  def conditional(value)
    case value
    when "if"
      @kw_stack << :orange
    else
    end
  end

  def proc_end(value)
    if @kw_stack.pop == :pink
      "<pink>#{value}</pink>"
    else
      "<orange>#{value}</orange>"
    end
  end

  def reset
    @def_flag = false
  end

  def run(file)
    init
    source = ""

    Ripper.lex(File.open(file)).each do |data|
      point, type, value = data

      if @line_num < point.first 
        reset
        @line_num += 1
      end

  
      p data
      case type
      when :on_ignored_nl
        source += "\n"
      when :on_int
        source += "<red>#{value}</red>"
      when :on_kw
        if PINK.include?(value)
          source += "<pink>#{value}</pink>"
          @kw_stack << :pink
          @def_flag = true if value == "def"
        elsif CONDITION.include?(value)
          source += "<orange>#{value}</orange>"
          conditional(value)
        elsif ["end"].include?(value)
            source += proc_end(value)
        else
          if @kw_stack.last == :pink
            source += "<pink>#{value}</pink>"
          else
            source += "<orange>#{value}</orange>"
          end
        end
      when :on_tstring_beg
        source += "<red>#{value}"
      when :on_tstring_end
        source += "#{value}</red>"
      when :on_comment
        source += "<blue>#{value.chomp}</blue>\n"
      when :on_const
        source += "<green>#{value}</green>"
      when :on_ident
        if @def_flag
          source += "<aqua>#{value}</aqua>"
        else
          source += value
        end
      else
        source += value
      end
    end

    source
  end
end

result = Ruby.parse("/Users/siman/Programming/ruby/sns_parser/example/test.rb")
puts result