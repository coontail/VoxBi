def csvToDico(csv)
dico = Hash[csv.split("\n").map {|ligne| ligne.split("#")}]
end

def apimatch(texte)
	texteAPI = []
	signesSpeciaux = ["-","\'","\"",",",":",";",".","(",")"]
	exceptions = csvToDico(File.open("exceptions.csv").read)
	conversion = csvToDico(File.open("conversion.csv").read)
	signesSpeciaux.each do |signe|
		texte = texte.replace(signe,"") if texte.include?(signe)
	end
	texte.split.each do |mot|
		texteAPI << ""
		if exceptions[mot]
			texteAPI[-1] = exceptions[mot]
		else
			unless mot.empty?
				conversion.keys.each do |regle|
					if mot =~ /#{regle}/
						texteAPI[-1] += conversion[regle].to_s
						mot = mot.sub(/#{regle}/,"")
					end
				end
			end
		end
	end
end

def voxbi(texte)
paires_dispo = File.open("paires_disponibles.txt").read.split("\n")
api = apimatch(texte).join "_"
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

