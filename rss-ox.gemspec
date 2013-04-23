Gem::Specification.new do |s|
  s.name = "rss-ox"
  s.version = "0.0.1"
  s.authors = "notezen"
  s.email = "notezen@gmail.com"
  s.homepage = "https://github.com/notezen/rss-ox"
  s.summary = "Ox parser for Ruby's RSS library"
  s.files = `git ls-files`.split($\)
  s.require_paths = ["lib"]
  s.add_dependency "ox"
end