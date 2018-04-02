#!/usr/bin/env ruby

require "require_all"
require_all "lib/**/*.rb"

ROOT_PATH = File.expand_path('..', __dir__).freeze
DATA_PATH = "#{ROOT_PATH}/data".freeze
DEFAULT_OUTPUT_FILENAME = 'pairs'
DEFAULT_OUTPUT_PATH = "#{DATA_PATH}/#{DEFAULT_OUTPUT_FILENAME}.wav".freeze

class Voxbi
  include Rulable

  memoize_json :dictionary

  attr_accessor :text

  def initialize(text)
    @text = text
  end

  def read
  	file_paths = normalized_pairs.map{ |pair| "#{DATA_PATH}/pairs/#{pair}.ogg" }
  	`sox #{file_paths.join(" ")} #{DEFAULT_OUTPUT_PATH}`
  	`aplay #{DEFAULT_OUTPUT_PATH}`
  end

  def get_pairs
    GetPairsService.new(linked_phonems).call
  end

  def get_syllables
    GetSyllablesService.new(linked_phonems).call
  end

  private

  def normalized_pairs
    get_pairs.map{ |pairs| pairs << '_' }.flatten
  end

  def prepared_text
    @prepared_text ||= PrepareTextService.new(text).call
  end

  def phonetic_text
    @phonetic_text ||= prepared_text.map do |word|
      dictionary[word] ||
      PhoneticsConverterService.new(word).call
    end
  end

  def linked_phonems
    LinkageService.new(prepared_text, phonetic_text).call
  end
end


