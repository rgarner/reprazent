module Reprazent
  ##
  # A helper to assist with forming VCard representations
  module VCardHelper
    [:FN, :N, :ORG, :ADR, :TEL, :EMAIL, :URL].each do |name|
      define_method name do |*args|
        vcard_method(name, *args)
      end
    end

    def vcard_method(*args)
      extras = ''
      if (args[-1].is_a? Hash) then
        args[-1].each_pair do |key, value|
          value_part = value.is_a?(Array) ? value.join(',') : value
          extras += "#{key}=#{value_part}"
        end
      end
      extras = ';' + extras unless extras.blank?
      "#{args[0]}#{extras}:#{args[1]}" if args[1] # only output if second parameter is there
    end
  end
end