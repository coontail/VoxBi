

def Test
  include Rulable

  attr_accessor :text

  def initialize(text)
    @text = text
  end

  def call
    apply_exceptions
  end

  private

  def apply_exceptions
    exceptions.each { |k,v| dictionary[k] = v }
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

  def apimatch
    linkage
  end

  def linkage
    LinkageService.new(prepared_text, phonetic_text).call
  end

  def Voxbi.get_pairs
    # paires_dispo = File.open("#{ROOT}/data/paires_disponibles.csv").read.split("\n")
    api = apimatch(prepared_text).join "_"
    pairs = []
    while api.length !=0
      paires_dispo.each do |pair|
        if api.match(/^#{pair}/)
          pairs << pair
          api = api.sub(/^#{pair}/,"")
          break
        end
      end
    end
    pairs
  end

  def Voxbi.get_syllables
    pairs = Voxbi.get_pairs(prepared_text) - ["_"]
    [''].tap do |syllables|
      pairs.each_with_index do |pair, index|
        if syllables.last =~ /[ɛøαϵiaoɔσyuœπeµwj]/
          if pair =~ /[ɛøαϵiaoɔσyuœπeµwj]/
            syllables << pair
          else
            syllables.last << pair
          end
        else
          syllables.last << pair
        end
      end
    end.reject(&:blank?)
  end
end
