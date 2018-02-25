class PhoneticsConverterService
  DEFAULT_TIMEOUT = 2.freeze

  attr_accessor :word

  def initialize(word)
    @word = word
  end

  def call
    with_timeout do
      phonetize_word
    end
  end

  private

  def with_timeout(&block)
    Timeout::timeout(DEFAULT_TIMEOUT) do
      block.call
    end
  end

  def phonetize_word
    dup_word = word.dup
    phonetized_word = ''

    until dup_word.empty?
      conversion_rule = conversion.select { |rule| dup_word =~ /#{rule}/ }.first
      conversion_rule.tap do |rule, phonetic|
        dup_word.sub! /#{rule}/, ''
        phonetized_word << phonetic.to_s
      end
    end
  end

end
