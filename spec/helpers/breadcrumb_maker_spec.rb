require "spec_helper"

describe Reprazent::BreadcrumbHelper do
  class Helper
    include Reprazent::BreadcrumbHelper
  end
  let(:helper) { Helper.new }

  module Breadcrumb
    SCHEME = 'http'
    HOST = 'localhost'
    PORT = 3000
  end

  def mock_request(path)
    stub(:host => Breadcrumb::HOST, :scheme => Breadcrumb::SCHEME, :path => path, :port => Breadcrumb::PORT)
  end

  describe "Breadcrumb generation" do

    describe "Generating the index breadcrumbs" do
      ROOT_LINK = '<a href="http://localhost:3000">...</a>'

      it "should return a single a to the root index when empty" do
        helper.breadcrumb(mock_request('')).should == ROOT_LINK
      end

      it "should return a single link to the root index when one slash" do
        helper.breadcrumb(mock_request('/')).should == ROOT_LINK
      end

      describe "Generating a breadcrumb with one level" do
        let(:breadcrumb) { helper.breadcrumb(mock_request('/EducationAndLearning')) }

        it "should always generate the root index part" do
          breadcrumb.should include ROOT_LINK
        end

        it "should not generate the EducationAndLearning part as we're already there" do
          breadcrumb.should_not include "href=\"/EducationAndLearning\""
        end

        it "should include the text of the last part" do
          breadcrumb.should include 'EducationAndLearning'
        end
      end

      describe "Generating a two level breadcrumb" do
        let(:breadcrumb) { helper.breadcrumb(mock_request('/contacts/LocalCouncil/AtoZ')) }

        it "should have the root link" do
          breadcrumb.should =~ Regexp.new(ROOT_LINK + '.*')
        end

        it "should produce a breadcrumb like this" do
          breadcrumb.should == ROOT_LINK + '/<a href="http://localhost:3000/contacts">contacts</a>' +
              '/<a href="http://localhost:3000/contacts/LocalCouncil">LocalCouncil</a>/AtoZ'
        end
      end

      describe "Generating a breadcrumb with a query string" do
        it "should not include the query string in the breadcrumb" do
          helper.breadcrumb(mock_request('/?q=hello')).should == ROOT_LINK
        end
      end

      describe "Generating breadcrumbs when in a non-hierarchical site section" do
        let(:breadcrumb) { helper.breadcrumb(mock_request('/id/article/DG_123')) }

        it "should have the root link" do
          breadcrumb.should =~ Regexp.new(ROOT_LINK + '.*')
        end

        it "should not create links for anything but home" do
          breadcrumb.should_not =~ %r{href="http://localhost:3000/id"}
        end

        it "should not create links for anything but home with /doc" do
          helper.breadcrumb(mock_request('/doc/article/DG_123')).
              should_not =~ %r{href="http://localhost:3000/doc"}
        end

        it "should not render a raw array (Ruby 1.9.2 breaking change)" do
          breadcrumb.should_not include('["id/", "article/", "DG_123/"]')
        end
      end
    end

  end
end