#!/usr/bin/rake
require 'pathname'
require 'shellwords'


## [ Constants ] ##############################################################

WORKSPACE = 'ModelGen'
SCHEME_NAME='modelgen'
CONFIGURATION = 'Release'
POD_NAME = 'ModelGen'
MIN_XCODE_VERSION = 9.0

BUILD_DIR = File.absolute_path('./build')
BIN_NAME = 'modelgen'
BINARIES_FOLDER = '/usr/local/bin'
FRAMEWORKS_FOLDER = '/usr/local/Frameworks'


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
    plist_file = (Pathname.new(BUILD_DIR) + "Build/Products/#{CONFIGURATION}/#{BIN_NAME}.app/Contents/Info.plist").to_s
    Utils.run(
      %Q(xcodebuild -workspace "#{WORKSPACE}.xcworkspace" -scheme "#{SCHEME_NAME}" -configuration "#{CONFIGURATION}") +
      %Q( -derivedDataPath "#{BUILD_DIR}") +
      %Q( MODELGEN_OTHER_LDFLAGS="-sectcreate __TEXT __info_plist #{plist_file.shellescape}"),
      task, xcrun: true, formatter: :xcpretty)
  end

  desc "Install the binary in $bindir, frameworks in $fmkdir\n" \
       "(defaults $bindir=./build/#{BIN_NAME}/bin/, $fmkdir=$bindir/../lib"
  task :install, [:bindir, :fmkdir] => :build do |task, args|
    (bindir, fmkdir) = defaults(args)
    generated_bundle_path = "#{BUILD_DIR}/Build/Products/#{CONFIGURATION}/#{BIN_NAME}.app/Contents"

    Utils.print_header "Installing binary in #{bindir}"
    Utils.run([
      %Q(mkdir -p "#{bindir}"),
      %Q(cp -f "#{generated_bundle_path}/MacOS/#{BIN_NAME}" "#{bindir}/#{BIN_NAME}"),
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
  
    Utils.print_header "Add Symbolic link"
    Utils.run([
      %Q(ln -s "#{bindir}/#{BIN_NAME}" "#{BINARIES_FOLDER}/#{BIN_NAME}")
    ], task, 'symbolic_link')

    Utils.print_info "Finished installing. Binary is available in: #{bindir}"
  end

  desc "Delete the build directory\n" \
     "(#{BUILD_DIR})"
  task :clean do
    sh %Q(rm -fr #{BUILD_DIR})
  end

  desc "Uninstall\n"
  task :uninstall do
    Utils.print_header "Remove previous versions"
    Utils.run([
      %Q(rm -rf "#{FRAMEWORKS_FOLDER}/Commander.framework"),
      %Q(rm -rf "#{FRAMEWORKS_FOLDER}/PathKit.framework"),
      %Q(rm -rf "#{FRAMEWORKS_FOLDER}/Stencil.framework"),
      %Q(rm -rf "#{FRAMEWORKS_FOLDER}/StencilSwiftKit.framework"),
      %Q(rm -rf "#{FRAMEWORKS_FOLDER}/Yams.framework"),
      %Q(rm -rf "#{FRAMEWORKS_FOLDER}/libswiftAppKit.dylib"),
      %Q(rm -rf "#{FRAMEWORKS_FOLDER}/libswiftCore.dylib"),
      %Q(rm -rf "#{FRAMEWORKS_FOLDER}/libswiftCoreData.dylib"),
      %Q(rm -rf "#{FRAMEWORKS_FOLDER}/libswiftCoreGraphics.dylib"),
      %Q(rm -rf "#{FRAMEWORKS_FOLDER}/libswiftCoreImage.dylib"),
      %Q(rm -rf "#{FRAMEWORKS_FOLDER}/libswiftDarwin.dylib"),
      %Q(rm -rf "#{FRAMEWORKS_FOLDER}/libswiftDispatch.dylib"),
      %Q(rm -rf "#{FRAMEWORKS_FOLDER}/libswiftFoundation.dylib"),
      %Q(rm -rf "#{FRAMEWORKS_FOLDER}/libswiftIOKit.dylib"),
      %Q(rm -rf "#{FRAMEWORKS_FOLDER}/libswiftObjectiveC.dylib"),
      %Q(rm -rf "#{FRAMEWORKS_FOLDER}/libswiftQuartzCore.dylib"),
      %Q(rm -rf "#{FRAMEWORKS_FOLDER}/libswiftXPC.dylib"),
      %Q(rm -f "#{BINARIES_FOLDER}/#{BIN_NAME}")
    ], task, 'uninstall')
  end
end

task :default => 'cli:build'
