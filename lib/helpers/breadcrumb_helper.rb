module Reprazent
  module BreadcrumbHelper
    ##
    # Create a site breadcrumb
    def breadcrumb(request)
      BreadcrumbMaker.new(request).to_s.html_safe
    end

    class BreadcrumbMaker
      def initialize(request)
        @request = request
        @root_url = "#{request.scheme}://#{request.host}#{':' + request.port.to_s unless request.port == 80}"
      end

      def to_s
        without_query = @request.path.gsub(/\?.*/, '')
        _breadcrumb without_query.split('/').reject { |s| s.blank? }
      end

      def _breadcrumb(path_parts, last_item = nil)
        raise RuntimeError.new "#{self.class}#_breadcrumb expects an array" unless path_parts.is_a? Array

        return "<a href=\"#{@root_url}\">...</a>" if path_parts.empty?
        return _breadcrumb([]) + '/' + path_parts.join('/') if ['id', 'doc', 'def'].include?(path_parts[0])

        this_part = path_parts.slice(-1)
        last_item = this_part if last_item.nil?
        return _breadcrumb(path_parts[0..-2], last_item) << "/#{this_part}" if this_part == last_item
        _breadcrumb(path_parts[0..-2], last_item) << "/<a href=\"#{absolute_url_for(path_parts)}\">#{this_part}</a>"
      end

      def absolute_url_for(path_parts)
        "#{@root_url}/" + path_parts.inject('') { |result, part| "#{result}#{'/' unless result.blank?}#{part}" }
      end
    end
  end
end