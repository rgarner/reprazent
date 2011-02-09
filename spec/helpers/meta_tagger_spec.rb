require "spec_helper"

describe Reprazent::VCardHelper do
  class Helper
    include Reprazent::MetaTaggerHelper
  end

  class Article
  end

  let(:helper) { Helper.new }
  let(:article) do
    a = Article.new
    a.stub(:subject => 's', :egms_id => 'DG_123')
    a
  end

  describe "optional meta tags" do
    it "should not render anything if the property isn't responded to" do
      helper.meta_tags(article) { meta 'DC.subject', :no_property }.should be_nil
    end

    it "should map from a single symbol" do
      helper.meta_tags(article) { meta :subject }.to_s.should include("<meta name=\"subject\" content=\"s\" />")
    end

    it "should render a meta tag for the same" do
      helper.meta_tags(article) { meta 'DC.subject' }.to_s.should include("<meta name=\"DC.subject\" content=\"s\" />")
    end

    it "should map a tag string to a symbol" do
      helper.meta_tags(article) { meta 'eGMS.systemID', :egms_id }.should include('<meta name="eGMS.systemID" content="DG_123" />')
    end

    it "should allow values" do
      helper.meta_tags(article) { meta 'someval', 2 * 4 }.should include('<meta name="someval" content="8" />')
    end

    it "should omit nils" do
      output = helper.meta_tags(article) { meta :description; meta :subject }
      output.should_not include('name="description"')
    end

    it "should concatenate values" do
      output = helper.meta_tags(article) do
        meta :egms_id
        meta :subject
      end

      output.should include('meta name="egms_id" content="DG_123"')
      output.should include('meta name="subject" content="s"')
    end
  end
end