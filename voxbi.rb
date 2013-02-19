def parseCSV(path)
  Hash[File.open("#{path}.csv").read.split("\n").map {|ligne| ligne.split("#")}]
end

def exceptions
  @exceptions ||= parseCSV "exceptions"
end

def conversion
  @conversion ||= parseCSV "conversion"
end

def apimatch(texte)
  texte.gsub(/-'",:;\.\(\)/, "").split.map do |mot|
    exceptions[mot] || "".tap do |result|
      conversion.select { |regle| mot =~ /#{regle}/ }.first.tap do |regle, api|
        mot.sub! /#{regle}/, ""
        result << api.to_s
      end until mot.empty?
    end
  end
end

def voxbi(texte)
  paires_dispo = File.open("paires_disponibles.txt").read.split("\n")
  api = apimatch(texte).join "_"
  puts api.inspect
  fichiers = []
  while api.length !=0
    paires_dispo.each do |paires|
      if api.match(/^#{paires}/)
        fichiers << "paires/"+paires+".ogg"
        api = api.sub(/^#{paires}/,"")
        break
      end
    end
  end
  system("sox "+fichiers.join(" ")+" paires.wav")
  system("aplay paires.wav")
end

voxbi(ARGV[0])
