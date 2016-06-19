#!/usr/bin/env ruby

require "json"
require "numbers_and_words"

module Voxbi

	ROOT = File.expand_path("../..", __FILE__)
	@output_path = "#{ROOT}/data/paires.wav"
	eval(File.read("#{ROOT}/lib/special_chars.rb"))

	def Voxbi.parseCSV(path)
		Hash[File.open("#{ROOT}/data/#{path}.csv").read.split("\n").map {|ligne| ligne.split("#")}]
	end

	def Voxbi.dict
		@dict ||= JSON.parse(File.read("#{ROOT}/data/phono.json"))
	end

	def Voxbi.exceptions
		@exceptions ||= parseCSV "exceptions"
	end

	def Voxbi.conversion
		@conversion ||= parseCSV "conversion"
	end

	def Voxbi.liaisons
		@liaisons ||= parseCSV "liaisons"
	end

	def Voxbi.set_output_path(path)
		@output_path = path
	end

	def Voxbi.output_path
		@output_path
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
				if index == 2
					syllables.last << pair
				end
				
				if pair =~ /[ɛøαϵiaoɔσyuœπeµwj]/
					syllables << pair
				else
					syllables.last << pair
				end
			end
		end
	end
		
	def Voxbi.voxbi(texte)
		fichiers = get_pairs(texte).map{ |pair| "#{ROOT}/data/paires/#{pair}.ogg" }
		`sox #{fichiers.join(" ")} #{output_path}`
		`aplay  #{output_path}`
	end


end
