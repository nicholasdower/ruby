require_relative '../../../spec_helper'

ruby_version_is ""..."3.5" do
  require 'cgi'
  require_relative 'fixtures/common'

  describe "CGI::HtmlExtension#caption" do
    before :each do
      @html = CGISpecs.cgi_new
    end

    describe "when passed a String" do
      it "returns a 'caption'-element, using the passed String for the 'align'-attribute" do
        output = @html.caption("left")
        output.should equal_element("CAPTION", "ALIGN" => "left")
      end

      it "includes the passed block's return value when passed a block" do
        output = @html.caption("left") { "Capital Cities" }
        output.should equal_element("CAPTION", {"ALIGN" => "left"}, "Capital Cities")
      end
    end

    describe "when passed a Hash" do
      it "returns a 'caption'-element, using the passed Hash for attributes" do
        output = @html.caption("ALIGN" => "left", "ID" => "test")
        output.should equal_element("CAPTION", "ALIGN" => "left", "ID" => "test")
      end

      it "includes the passed block's return value when passed a block" do
        output = @html.caption("ALIGN" => "left", "ID" => "test") { "Capital Cities" }
        output.should equal_element("CAPTION", {"ALIGN" => "left", "ID" => "test"}, "Capital Cities")
      end
    end
  end
end
