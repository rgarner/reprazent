module Reprazent::MetaTaggerHelper
  class MetaTagger
    attr_reader :item

    def initialize(item)
      @item = item
      @buffer = ''
    end

    def content_if_available(symbol)
      @item.send(symbol.to_s.gsub(' ', '_').to_sym) rescue nil
    end

    ##
    # Generate a meta tag for some property on this item. Generates nothing
    # if the property does not exist.
    #
    # Examples:
    #
    # When invoked on a content item where <code>language=="en"</code> and
    # <code>egms_id="DG_123"</code>:
    #    meta :language
    #       -> <meta name="language" content="en" />
    #    meta 'DCTERMS.language'
    #       -> <meta name="DCTERMS.language" content="en" />
    #    meta 'eGMS.identifier.systemID', :egms_id
    #       -> <meta name="eGMS.identifier.systemID", content="DG_123" />
    #    meta :does_not_exist
    #       -> <code>nil</code>
    def meta(*args, &block)
      tag_name = args[0]

      content = if tag_name.is_a?(Symbol)
                  content_if_available(tag_name)
                elsif args[1] && !args[1].is_a?(Symbol)
                  args[1]
                elsif tag_name.is_a?(String)
                  # Deal with 'Some.subject' case
                  if args[1].is_a?(Symbol)
                    content_if_available(args[1])
                  else
                    match = tag_name.match(/.*\.(.*)/)
                    match ? content_if_available(match[1]) : content_if_available(tag_name)
                  end
                else
                  raise ArgumentError, "meta(*args) expects a String or a Symbol (got a #{tag_name.class})"
                end

      @buffer += "<meta name=\"#{tag_name.to_s}\" content=\"#{content}\" />\r\n" unless content.nil?
    end

    def buffer(&block)
      self.instance_eval(&block)
      @buffer.blank? ? nil : @buffer.html_safe
    end
  end

  ##
  # Generate tags for some object
  def meta_tags(model, &block)
    MetaTagger.new(model).buffer(&block)
  end
end
