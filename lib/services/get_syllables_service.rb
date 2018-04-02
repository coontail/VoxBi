class GetSyllablesService

  VOCALIC_PHONEMS_REGEXP = /[ɛøαϵiaoɔσyuœπe]/
  GLIDES_REGEXP = /[µwj]/

  attr_reader :phonetic_text

  def initialize(phonetic_text)
    @phonetic_text = phonetic_text
  end

  def call
    get_pairs_for(phonetic_text).map do |word_pairs|
      get_syllables_for(word_pairs)
    end.flatten.reject(&:blank?)
  end

  private

  def get_syllables_for(pairs)
    [''].tap do |syllables|
      pairs.each do |pair|
        if has_vocalic_phonem?(syllables.last) && has_vocalic_phonem?(pair)
          syllables << pair
        else
          syllables.last << pair
        end
      end
    end
  end

  def get_pairs_for(text)
    GetPairsService.new(text).call
  end

  def has_vocalic_phonem?(pair)
    !!(pair =~ VOCALIC_PHONEMS_REGEXP)
  end

  def is_glide?(pair)
    pair.length == 1 && !!(pair =~ GLIDES_REGEXP)
  end
end
