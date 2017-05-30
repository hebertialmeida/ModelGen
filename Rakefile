#!/usr/bin/rake
require 'pathname'
require 'yaml'
require 'shellwords'


## [ Constants ] ##############################################################

WORKSPACE = 'ModelGen'
SCHEME_NAME='modelgen'
CONFIGURATION = 'Release'
POD_NAME = 'ModelGen'

BUILD_DIR = File.absolute_path('./build')
BIN_NAME = 'modelgen'


## [ Utils ] ##################################################################

def defaults(args)
  bindir = args.bindir.nil? || args.bindir.empty? ? (Pathname.new(BUILD_DIR) + 'modelgen/bin') : Pathname.new(args.bindir)
  fmkdir = args.fmkdir.nil? || args.fmkdir.empty? ? bindir + '../lib' : Pathname.new(args.fmkdir)
  [bindir, fmkdir].map(&:expand_path)
end

## [ Build Tasks ] ############################################################

namespace :cli do
  desc "Build the CLI binary and its frameworks as an app bundle\n" \
       "(in #{BUILD_DIR})"
  task :build, [:bindir] do |task, args|
    (bindir, _) = defaults(args)
    
    Utils.print_header "Building Binary"
    plist_file = (Pathname.new(BUILD_DIR) + "Build/Products/#{CONFIGURATION}/modelgen.app/Contents/Info.plist").to_s
    Utils.run(
      %Q(xcodebuild -workspace "#{WORKSPACE}.xcworkspace" -scheme "#{SCHEME_NAME}" -configuration "#{CONFIGURATION}") +
      %Q( -derivedDataPath "#{BUILD_DIR}") +
      %Q( SWIFTGEN_OTHER_LDFLAGS="-sectcreate __TEXT __info_plist #{plist_file.shellescape}"),
      task, xcrun: true, formatter: :xcpretty)
  end

  desc "Install the binary in $bindir, frameworks in $fmkdir\n" \
       "(defaults $bindir=./build/modelgen/bin/, $fmkdir=$bindir/../lib"
  task :install, [:bindir, :fmkdir] => :build do |task, args|
    (bindir, fmkdir) = defaults(args)
    generated_bundle_path = "#{BUILD_DIR}/Build/Products/#{CONFIGURATION}/modelgen.app/Contents"

    Utils.print_header "Installing binary in #{bindir}"
    Utils.run([
      %Q(mkdir -p "#{bindir}"),
      %Q(cp -f "#{generated_bundle_path}/MacOS/modelgen" "#{bindir}/#{BIN_NAME}"),
    ], task, 'copy_binary')

    Utils.print_header "Installing frameworks in #{fmkdir}"
    Utils.run([
      %Q(if [ -d "#{fmkdir}" ]; then rm -rf "#{fmkdir}"; fi),
      %Q(mkdir -p "#{fmkdir}"),
      %Q(cp -fR "#{generated_bundle_path}/Frameworks/" "#{fmkdir}"),
    ], task, 'copy_frameworks')

    Utils.print_header "Fixing binary's @rpath"
    Utils.run([
      %Q(install_name_tool -delete_rpath "@executable_path/../Frameworks" "#{bindir}/#{BIN_NAME}"),
      %Q(install_name_tool -add_rpath "@executable_path/#{fmkdir.relative_path_from(bindir)}" "#{bindir}/#{BIN_NAME}"),
    ], task, 'fix_rpath', xcrun: true)
   
    Utils.print_info "Finished installing. Binary is available in: #{bindir}"
  end

  desc "Delete the build directory\n" \
     "(#{BUILD_DIR})"
  task :clean do
    sh %Q(rm -fr #{BUILD_DIR})
  end
end

task :default => 'cli:build'

## [ ChangeLog ] ##############################################################

namespace :changelog do
  LINKS_SECTION_TITLE = 'Changes in other ModelGen modules'

  desc 'Add links to other CHANGELOGs in the topmost ModelGen CHANGELOG entry'
  task :links do
    changelog = File.read('CHANGELOG.md')
    abort('Links seems to already exist for latest version entry') if /^### (.*)/.match(changelog)[1] == LINKS_SECTION_TITLE
    links = linked_changelogs(
      swiftgenkit: Utils.podfile_lock_version('SwiftGenKit'),
      stencilswiftkit: Utils.podfile_lock_version('StencilSwiftKit'),
      stencil: Utils.podfile_lock_version('Stencil') { `git describe --abbrev=0 --tags`.chomp }
    )
    changelog.sub!(/^##[^#].*$\n/, "\\0\n#{links}")
    File.write('CHANGELOG.md', changelog)
  end

  def linked_changelogs(swiftgenkit: nil, stencilswiftkit: nil, stencil: nil, templates: nil)
    return <<-LINKS.gsub(/^\s*\|/,'')
      |### #{LINKS_SECTION_TITLE}
      |
      |* [SwiftGenKit #{swiftgenkit}](https://github.com/SwiftGen/SwiftGenKit/blob/#{swiftgenkit}/CHANGELOG.md)
      |* [StencilSwiftKit #{stencilswiftkit}](https://github.com/SwiftGen/StencilSwiftKit/blob/#{stencilswiftkit}/CHANGELOG.md)
      |* [Stencil #{stencil}](https://github.com/kylef/Stencil/blob/#{stencil}/CHANGELOG.md)
    LINKS
  end
end
