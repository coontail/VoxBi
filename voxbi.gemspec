Gem::Specification.new do |s|
  s.name        = 'voxbi'
  s.version     = '0.3.2'
  s.date        = '2013-09-22'
  s.summary     = "VoxBi"
  s.description = "Easy-to-use french voice synthesizer"
  s.authors     = ["Galaad Gauthier"]
  s.email       = 'coontail7@gmail.com'
  s.files       = Dir['**/*']
  s.executables  = ["voxbi"]
  s.require_path = 'lib'
  s.homepage    =
    'https://github.com/Galaad-Gauthier/VoxBi'
  s.license       = 'MIT'
  s.add_dependency "json"
  s.add_dependency "numbers_and_words"
end
