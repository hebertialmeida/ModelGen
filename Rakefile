#!/usr/bin/rake
require 'pathname'
require 'shellwords'


## [ Constants ] ##############################################################

WORKSPACE = 'ModelGen'.freeze
SCHEME_NAME='modelgen'.freeze
CONFIGURATION = 'Debug'.freeze
RELEASE_CONFIGURATION = 'Release'.freeze
POD_NAME = 'ModelGen'.freeze
MIN_XCODE_VERSION = 9.3

BUILD_DIR = File.absolute_path('./build')
BIN_NAME = 'modelgen'

## [ Utils ] ##################################################################

def defaults(args)
  bindir = args.bindir.nil? || args.bindir.empty? ? (Pathname.new(BUILD_DIR) + "#{BIN_NAME}/bin") : Pathname.new(args.bindir)
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
    plist_file = (Pathname.new(BUILD_DIR) + "Build/Products/#{RELEASE_CONFIGURATION}/#{BIN_NAME}.app/Contents/Info.plist").to_s
    Utils.run(
      %Q(xcodebuild -workspace "#{WORKSPACE}.xcworkspace" -scheme "#{SCHEME_NAME}" -configuration "#{RELEASE_CONFIGURATION}") +
      %Q( -derivedDataPath "#{BUILD_DIR}") +
      %Q( MODELGEN_OTHER_LDFLAGS="-sectcreate __TEXT __info_plist #{plist_file.shellescape}"),
      task, xcrun: true, formatter: :xcpretty)
  end

  desc "Install the binary in $bindir, frameworks in $fmkdir\n" \
       "(defaults $bindir=./build/#{BIN_NAME}/bin/, $fmkdir=$bindir/../lib"
  task :install, %i[bindir fmkdir] => :build do |task, args|
    (bindir, fmkdir) = defaults(args)
    generated_bundle_path = "#{BUILD_DIR}/Build/Products/#{RELEASE_CONFIGURATION}/#{BIN_NAME}.app/Contents"

    Utils.print_header "Installing binary in #{bindir}"
    Utils.run([
      %(mkdir -p "#{bindir}"),
      %(cp -f "#{generated_bundle_path}/MacOS/#{BIN_NAME}" "#{bindir}/#{BIN_NAME}")
    ], task, 'copy_binary')

    Utils.print_header "Installing frameworks in #{fmkdir}"
    Utils.run([
      %(if [ -d "#{fmkdir}" ]; then rm -rf "#{fmkdir}"; fi),
      %(mkdir -p "#{fmkdir}"),
      %(cp -fR "#{generated_bundle_path}/Frameworks/" "#{fmkdir}")
    ], task, 'copy_frameworks')

    # Utils.print_header "Fixing binary's @rpath"
    # Utils.run([
    #   %(install_name_tool -delete_rpath "@executable_path/../Frameworks" "#{bindir}/#{BIN_NAME}"),
    #   %(install_name_tool -add_rpath "@executable_path/#{fmkdir.relative_path_from(bindir)}" "#{bindir}/#{BIN_NAME}")
    # ], task, 'fix_rpath', xcrun: true)

    Utils.print_info "Finished installing. Binary is available in: #{bindir}"
  end

  desc "Delete the build directory\n" \
     "(#{BUILD_DIR})"
  task :clean do
    sh %Q(rm -fr #{BUILD_DIR})
  end
end

task :default => 'cli:build'
