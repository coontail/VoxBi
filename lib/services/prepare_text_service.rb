require "numbers_and_words"

class PrepareTextService
  SPECIAL_CHARACTERS = /([•|—|–|\-|\’|,|?|!|^|\r|°|“|”|...|\u00a0|«|»|…|\\|\/|!|?|\"|\'|\[|\]|\(|\)|\]|<|>|=|+|%|$|&|#|;|*|:|}|{|`])/.freeze

  attr_accessor :text, :prepared_text

  def initialize(text)
    @text = text
  end

  def call
    dup_text
    remove_special_characters!
    split_text!
    wordify_numbers!

    prepared_text
  end

  private

  def dup_text
    prepared_text = text.dup
  end

  def remove_special_characters!
    prepared_tex.gsub!(SPECIAL_CHARACTERS, "")
  end

  def split_text!
    prepared_text.split!
  end

  def wordify_numbers!
    prepared_text.map! do |word|
      word.to_i != 0 ? word_for(word.to_i) : word
    end.flatten!
  end

  def word_for(number)
    I18n.with_locale(:fr) do
      number.to_words.gsub("-"," ").split
    end
  end

end
