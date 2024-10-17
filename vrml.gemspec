Gem::Specification.new do |s|
   s.name                  = "vrml"
   s.version               = "1.0.4"
   s.summary               = "VRML Syntax Highlighter"
   s.description           = "Adds suport for VRML syntax highlighting to Jekyll."
   s.authors               = ["Holger Seelig"]
   s.email                 = "holger.seelig@google.com"
   s.files                 = ["_plugins/vrml.rb"]
   s.homepage              = "https://create3000.github.io/x_ite/"
   s.license               = "MIT"
   s.required_ruby_version = ">= 2.0"

   s.add_development_dependency "jekyll", "~> 4.0"
 end
