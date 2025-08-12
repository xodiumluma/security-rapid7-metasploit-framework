module Metasploit
  module Framework
    # ActiveModel custom validator that assumes the attribute is supposed to be a regular file path;
    # checks whether file exists and whether it's a regular file or not
    class FilePathValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        unless value && ::File.file?(value)
          record.errors.add(attribute, (options[:message] || "isn't a regular file path"))
        end
      end
    end
  end
end
