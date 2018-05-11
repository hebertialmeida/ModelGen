class Modelgen < Formula
  desc "Swift CLI to generate Models based on a JSON Schema and a template."
  homepage "https://github.com/hebertialmeida/ModelGen"
  url "https://github.com/hebertialmeida/ModelGen.git"
      :branch => "master"
      # :tag => "0.1.0",
      # :revision => "930c017c0a066f6be0d9f97a867652849d3ce448"
  head "https://github.com/hebertialmeida/ModelGen.git"

  depends_on :xcode => ["9.3", :build]

  def install
    ENV["NO_CODE_LINT"]="1" # Disable swiftlint Build Phase to avoid build errors if versions mismatch

    system "gem", "install", "bundler"
    system "bundle", "install", "--without", "development"
    system "bundle", "exec", "rake", "cli:install[#{bin},#{lib}]"
  end

  test do
    system bin/"modelgen", "--version"
  end
end