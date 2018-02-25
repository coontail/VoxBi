class LinkageService

  def initialize(prepared_text, phonetic_text)
    @prepared_text = prepared_text
    @phonetic_text = phonetic_text
  end

  def call
    dup_phonetic_text
    apply_linkage
  end

  private

  def dup_phonetic_text
    @dup_phonetic_text ||= phonetic_text.dup
  end

  def apply_linkage
    prepared_text.each_with_index do |word, index|
      if @dup_phonetic_text[index+1]
        link = word[-1] + @dup_phonetic_text[index+1][0]
        match = linkage.select {|k,v| link =~ /#{k}/ }.first
        match ? @dup_phonetic_text[index+1] = match[1].to_s + @dup_phonetic_text[index+1] : next
      end
    end
  end

end
