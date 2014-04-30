require 'pp'
require 'ripper'

class Ruby
  PINK = ["class","def"].freeze
  CONDITION = ["if","else"].freeze
  ORANGE = ["if"].freeze
  COLOR_LIST = {
    red: '<op:color code="#ff0000">',
    blue: '<op:color code="#0000ff">',
    pink: '<op:color code="#ff00ff">',
    orange: '<op:color code="#ffa500">',
    green: '<op:color code="#00ff00">'
  }

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
      "#{COLOR_LIST[:pink]}#{value}</op:color>"
    else
      "#{COLOR_LIST[:orange]}#{value}</op:color>"
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
        source += "#{COLOR_LIST[:red]}#{value}</op:color>"
      when :on_kw
        if PINK.include?(value)
          source += "#{COLOR_LIST[:pink]}#{value}</op:color>"
          @kw_stack << :pink
          @def_flag = true if value == "def"
        elsif CONDITION.include?(value)
          source += "#{COLOR_LIST[:orange]}#{value}</op:color>"
          conditional(value)
        elsif ["end"].include?(value)
            source += proc_end(value)
        else
          if @kw_stack.last == :pink
            source += "#{COLOR_LIST[:pink]}#{value}</op:color>"
          else
            source += "#{COLOR_LIST[:orange]}#{value}</op:color>"
          end
        end
      when :on_tstring_beg
        source += "#{COLOR_LIST[:red]}#{value}"
      when :on_tstring_end
        source += "#{value}</op:color>"
      when :on_comment
        source += "#{COLOR_LIST[:blue]}#{value.chomp}</op:color>\n"
      when :on_const
        source += "#{COLOR_LIST[:green]}{#{value}</op:color>"
      when :on_ident
        if @def_flag
          source += "<aqua>#{value}</op:color>"
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

result = Ruby.parse("../../example/test.rb")
puts result
