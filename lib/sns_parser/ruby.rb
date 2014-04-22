require 'pp'
require 'ripper'

class Ruby
  def initialize
  end

  def parse(file)
    result = Ripper.lex(File.open(file))

    result.each do |res|
      checker(*res[0], res[1], res[2])
    end
  end

  def checker( line, column, symbol, value )
    puts "symbol = #{symbol}, value = #{value}"
  end
end
