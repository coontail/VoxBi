require "timeout"

class PhoneticsConverterService
  DEFAULT_TIMEOUT = 5.freeze

  attr_accessor :word, :phonetized_word

  def initialize(word)
    @word = word
    @phonetized_word = ''
  end

  def call
    with_timeout { phonetize_word }
    phonetized_word
  end

  private

  def with_timeout(&block)
    Timeout::timeout(DEFAULT_TIMEOUT) do
      block.call
    end
  end

  def phonetize_word
    dup_word = word.dup

    until dup_word.empty?
      conversion_rule_for(dup_word).tap do |rule, phonetic|
        dup_word.sub! /#{rule}/, ''
        phonetized_word << phonetic.to_s
      end
    end
  end

  def conversion_rule_for(word)
    RuleStore.conversion.detect{ |rule, phonetic| word =~ /#{rule}/ }
  end
end
