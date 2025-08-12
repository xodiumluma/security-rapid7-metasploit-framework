module Metasploit
  module Framework
    # ActiveModel custom validator tht assumes the attribute is supposed to be the path to a normal file
    # It checks whether the file exists amd whether or not it has an executable flag
    class ExecutablePathValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        unless ::File.executable? value
          record.errors.add(attribute, (options[:message] || "isn't a valid path to an executable file"))
        end
      end
    end
  end
end
