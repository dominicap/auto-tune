lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'autotune/version'

Gem::Specification.new do |spec|
  spec.name          = "autotune"
  spec.version       = AutoTune::VERSION
  spec.authors       = ["Dominic Antony Philip"]
  spec.email         = ["domi.a.philip@gmail.com"]

  spec.summary       = "A music auto-tagging library using the iTunes API & Spotify API"
  spec.description   = "AutoTune is a library that automates the task of adding metadata to music with the help of the iTunes Affiliates Search API & Spotify API."
  spec.homepage      = "https://github.com/dominicap/auto-tune"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.4"

  spec.add_runtime_dependency "taglib-ruby", "~> 0.7.0"
end
