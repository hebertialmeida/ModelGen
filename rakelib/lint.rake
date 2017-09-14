# Used constants:
# - WORKSPACE

namespace :lint do
  desc 'Install swiftlint'
  task :install do |task|
    next if system('which swiftlint > /dev/null')

    url = 'https://github.com/realm/SwiftLint/releases/download/0.21.0/SwiftLint.pkg'
    tmppath = '/tmp/SwiftLint.pkg'

    Utils.run([
      "curl -Lo #{tmppath} #{url}",
      "sudo installer -pkg #{tmppath} -target /"
    ], task)
  end
  
  if File.directory?('Sources')
    desc 'Lint the code'
    task :code => :install do |task|
      Utils.print_header 'Linting the code'
      Utils.run(%Q(swiftlint lint --no-cache --config .swiftlint.yml --strict), task)
    end
  end
end
