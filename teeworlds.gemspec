Gem::Specification.new do |s|
  s.name        = 'teeworlds'
  s.version     = '1.0.0'
  s.date        = '2013-04-13'
  s.summary     = "Teeworlds"
  s.description = "Classes to parse Teeworlds servers"
  s.authors     = ["Maciej Borosiewicz"]
  s.email       = 'm.borosiewicz@gmail.com'
  s.files       = `git ls-files`.split("\n")
  s.test_files  = s.files.grep(/^spec\//)
  s.homepage    = ''
end
