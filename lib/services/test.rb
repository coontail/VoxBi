# class Test
#   include Rulable

#   attr_accessor :text

#   def initialize(text)
#     @text = text
#   end

#   def call
#     apply_exceptions
#     apimatch
#   end

#   private

#   def apply_exceptions
#     exceptions.each { |k,v| dictionary[k] = v }
#   end

#   def prepared_text
#     @prepared_text ||= PrepareTextService.new(text).call
#   end

#   def phonetic_text
#     @phonetic_text ||= prepared_text.map do |word|
#       dictionary[word] ||
#       PhoneticsConverterService.new(word).call
#     end
#   end

#   def apimatch
#     linkage
#   end

#   def linkage
#     LinkageService.new(prepared_text, phonetic_text).call
#   end

#   def get_pairs
#     GetPairsService.new(phonetic_text).call
#   end

#   def get_syllables
#     GetSyllablesService.new(apimatch).call
#   end

# end
