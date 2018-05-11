class Modelgen < Formula
  desc "Swift CLI to generate Models based on a JSON Schema and a template."
  homepage "https://github.com/hebertialmeida/ModelGen"
  url "https://github.com/hebertialmeida/ModelGen.git",
      :tag => "0.3.0",
      :revision => "22ca2343cd65a4df4a039eef004ba5a75a0609fc"
  head "https://github.com/hebertialmeida/ModelGen.git"

  depends_on :xcode => ["9.3", :build]

  def install
    ENV["NO_CODE_LINT"]="1" # Disable swiftlint Build Phase to avoid build errors if versions mismatch

    ENV["GEM_HOME"] = buildpath/"gem_home"
    system "gem", "install", "bundler"
    ENV.prepend_path "PATH", buildpath/"gem_home/bin"
    system "bundle", "install", "--without", "development"
    system "bundle", "exec", "rake", "cli:install[#{bin},#{lib}]"
  end

  test do
    system bin/"modelgen", "--version"
  end
end