#!/usr/bin/env ruby

require "json"

ROOT = File.expand_path("../..", __FILE__)
SPE = /([(0-9)|•|—|–|\-|\’|,|?|!|^|\r|°|“|”|...|\u00a0|«|»|…|\\|\/|!|?|\"|\'|\[|\]|\(|\)|\]|<|>|=|+|%|$|&|#|;|*|:|}|{|`])/

def parseCSV(path)
	Hash[File.open("#{ROOT}/data/#{path}.csv").read.split("\n").map {|ligne| ligne.split("#")}]
end

def exceptions
	@exceptions ||= JSON.parse(File.read("#{ROOT}/data/phono.json"))
end

def conversion
	@conversion ||= parseCSV "conversion"
end

def liaisons
	@liaisons ||= parseCSV "liaisons"
end

def clean(texte)
	return texte.downcase.gsub(SPE, "").split
end

def apimatch(texte)
	graphie = clean(texte)
	clean_text = clean(texte)
	phono = clean_text.map do |mot|
		exceptions[mot] || "".tap do |result|
			conversion.select { |regle| mot =~ /#{regle}/ }.first.tap do |regle, api|
				mot.sub! /#{regle}/, ""
				result << api.to_s
			end until mot.empty?
		end
	end
	return liaison(graphie,phono)
end

def liaison(texte,phono)
	texte.each_with_index do |mot,id|
		if phono[id+1]
			lien = mot[-1] + phono[id+1][0]
			match = liaisons.select {|k,v| lien =~ /#{k}/ }.first
			match ? phono[id+1] = match[1].to_s + phono[id+1] : next
		end
	end
	return phono
end
	
	

def voxbi(texte)
	paires_dispo = File.open("#{ROOT}/data/paires_disponibles.csv").read.split("\n")
	api = apimatch(texte).join "_"
	puts api.inspect
	fichiers = []
	while api.length !=0
		paires_dispo.each do |paires|
			if api.match(/^#{paires}/)
				fichiers << "#{ROOT}/data/paires/#{paires}.ogg"
				api = api.sub(/^#{paires}/,"")
				break
			end
		end
	end
	`sox #{fichiers.join(" ")} #{ROOT}/data/paires.wav`
	`aplay  #{ROOT}/data/paires.wav`
end
