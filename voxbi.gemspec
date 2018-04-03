Gem::Specification.new do |s|
  s.name          = 'voxbi'
  s.version       = '1.0.5'
  s.date          = '2018-04-03'
  s.summary       = "VoxBi"
  s.description   = "Easy-to-use french voice synthesizer"
  s.authors       = ["Galaad Gauthier"]
  s.email         = 'coontail7@gmail.com'
  s.files         = Dir['**/*']
  s.executables   = ["voxbi"]
  s.require_path  = 'lib'
  s.homepage      = 'https://github.com/Galaad-Gauthier/VoxBi'
  s.license       = 'MIT'
  s.add_dependency "json"
  s.add_dependency "numbers_and_words"
  s.add_dependency "require_all"
end
