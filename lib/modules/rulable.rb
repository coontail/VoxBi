require "json"

module Rulable

  CSV_FILENAMES = %w(conversion linkage exceptions paires_disponibles).freeze
  JSON_FILENAMES = %w(dictionary)

  CSV_FILENAMES.each do |filename|
    define_method(filename) do
      instance_variable_get("@#{filename}") ||
      instance_variable_set("@#{filename}",
        Hash[CSV.read("#{DATA_PATH}/#{filename}.csv", col_sep: '#')]
      )
    end
  end

  JSON_FILENAMES.each do |filename|
    define_method(filename) do
      instance_variable_get("@#{filename}") ||
      instance_variable_set("@#{filename}", JSON.parse(File.read(filename)))
    end
  end

end
