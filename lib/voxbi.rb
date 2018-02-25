#!/usr/bin/env ruby

ROOT = File.expand_path("../..", __FILE__).freeze
DATA_PATH = "#{ROOT}/data".freeze
DEFAULT_OUTPUT_PATH = "#{DATA_PATH}/paires.wav".freeze

class Voxbi
	def initialize(text, output_path: DEFAULT_OUTPUT_PATH)
		@text = text
		@output_path = output_path
	end

	def parse_csv(path)
		content = File.open("#{DATA_PATH}#{path}.csv").read
		rows = content.split("\n").map {|ligne| ligne.split("#")}]
		Hash[rows]
	end

	def Voxbi.apply_exceptions
		exceptions.each { |k,v| dict[k] = v }
	end

	def Voxbi.clean(texte)
		new_text = texte.downcase.gsub(SPE, "").split
		new_text.map! do |word|
			if word.to_i != 0
				I18n.with_locale(:fr) { word.to_i.to_words.gsub("-"," ").split}
			else
				word
			end
		end
		return new_text.flatten
	end

	def Voxbi.phono(text)
		apply_exceptions

		Timeout::timeout(2) do
			clean(text).map do |mot|
				dict[mot] || "".tap do |result|
					conversion.select { |regle| mot =~ /#{regle}/ }.first.tap do |regle, api|
						mot.sub! /#{regle}/, ""
						result << api.to_s
					end until mot.empty?
				end
			end
		end
	rescue
		[]
	end

	def Voxbi.apimatch(texte)
		apply_exceptions
		graphie = clean(texte)
		phono = phono(texte)

		return liaison(graphie,phono)
	end

	def Voxbi.liaison(texte,phono)
		texte.each_with_index do |mot,id|
			if phono[id+1]
				lien = mot[-1] + phono[id+1][0]
				match = liaisons.select {|k,v| lien =~ /#{k}/ }.first
				match ? phono[id+1] = match[1].to_s + phono[id+1] : next
			end
		end
		return phono
	end

	def Voxbi.get_pairs(texte)
		paires_dispo = File.open("#{ROOT}/data/paires_disponibles.csv").read.split("\n")
		api = apimatch(texte).join "_"
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

  def Voxbi.get_syllables(text)
    pairs = Voxbi.get_pairs(text) - ["_"]
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

	def read
		file_paths = get_pairs(texte).map{ |pair| "#{DATA_PATH}/pairs/#{pair}.ogg" }
		`sox #{file_paths.join(" ")} #{output_path}`
		`aplay #{output_path}`
	end


end
