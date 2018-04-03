class RuleStore
  include RuleParsable

  CSV_FILENAMES = %i(conversion linkage exceptions available_pairs).freeze
  JSON_FILENAMES = %i(dictionary).freeze

  def self.class_memoize(filename, file_format)
    class_variable_set(:"@@#{filename}", parse_rule_file(filename, file_format))

    self.define_singleton_method(filename) do
      class_variable_get(:"@@#{filename}")
    end
  end

  CSV_FILENAMES.each do |filename|
    class_memoize filename, :csv
  end

  JSON_FILENAMES.each do |filename|
    class_memoize filename, :json
  end
end
