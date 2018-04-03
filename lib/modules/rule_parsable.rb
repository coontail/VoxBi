require "json"
require "csv"

module RuleParsable
  DATA_PATH = File.expand_path('../../data', __dir__)

  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def parse_rule_file(filename, file_format)
      absolute_file_path = absolute_path_for(filename, file_format)

      case file_format
      when :csv then parse_csv(absolute_file_path)
      when :json then JSON.parse(File.read(absolute_file_path))
      end
    end

    def parse_csv(file_path)
      parsed_csv = CSV.read(file_path, col_sep: '#')
      parsed_csv.first.length > 1 ? Hash[parsed_csv] : parsed_csv.flatten
    end

    def absolute_path_for(filename, file_format)
      "#{DATA_PATH}/#{filename}" + ".#{file_format}"
    end
  end
end
