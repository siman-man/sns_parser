require 'sns_parser'
require 'spec_helper'

describe "sns for ruby" do
  describe "ruby parser" do
    it "should be file parse" do
      parser = Ruby.new
      parser.parse("example/test.rb")
    end
  end
end
