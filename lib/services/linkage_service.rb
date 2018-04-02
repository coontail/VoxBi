class LinkageService
  include Rulable

  attr_accessor :prepared_text, :phonetic_text

  def initialize(prepared_text, phonetic_text)
    @prepared_text = prepared_text
    @phonetic_text = phonetic_text
  end

  def call
    dup_phonetic_text
    apply_linkage

    @dup_phonetic_text
  end

  private

  def dup_phonetic_text
    @dup_phonetic_text ||= phonetic_text.dup
  end

  def apply_linkage
    prepared_text.each_with_index do |word, index|
      if @dup_phonetic_text[index+1]
        link_string = word[-1] + @dup_phonetic_text[index+1][0]
        linkage_rule = linkage_rule_for(link_string)

        if linkage_rule
          @dup_phonetic_text[index+1] = linkage_rule[1].to_s + @dup_phonetic_text[index+1]
        end
      end
    end
  end

  def linkage_rule_for(link_string)
    linkage.select {|k,v| link_string =~ /#{k}/ }.first
  end

end
