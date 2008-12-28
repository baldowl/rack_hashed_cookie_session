--- !ruby/object:Gem::Specification 
name: rack_hashed_cookie_session
version: !ruby/object:Gem::Version 
  version: 0.0.0
platform: ruby
authors: 
- Emanuele Vicentini
autorequire: 
bindir: bin

date: 2008-12-28 00:00:00 +01:00
default_executable: 
dependencies: 
- !ruby/object:Gem::Dependency 
  name: rack
  type: :runtime
  version_requirement: 
  version_requirements: !ruby/object:Gem::Requirement 
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: "0"
    version: 
- !ruby/object:Gem::Dependency 
  name: echoe
  type: :development
  version_requirement: 
  version_requirements: !ruby/object:Gem::Requirement 
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: "0"
    version: 
description: Hashed cookie-based session store for Rack
email: emanuele.vicentini@gmail.com
executables: []

extensions: []

extra_rdoc_files: 
- lib/rack/session/hashed_cookie.rb
- LICENSE.rdoc
- README.rdoc
files: 
- lib/rack/session/hashed_cookie.rb
- LICENSE.rdoc
- Manifest
- rack_hashed_cookie_session.gemspec
- Rakefile
- README.rdoc
has_rdoc: true
homepage: ""
post_install_message: 
rdoc_options: 
- --line-numbers
- --inline-source
- --title
- Rack_hashed_cookie_session
- --main
- README.rdoc
require_paths: 
- lib
required_ruby_version: !ruby/object:Gem::Requirement 
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "0"
  version: 
required_rubygems_version: !ruby/object:Gem::Requirement 
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "1.2"
  version: 
requirements: []

rubyforge_project: 
rubygems_version: 1.3.1
specification_version: 2
summary: Hashed cookie-based session store for Rack
test_files: []
