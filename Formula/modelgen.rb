class Modelgen < Formula
  desc "Swift CLI to generate Models based on a JSON Schema and a template."
  homepage "https://github.com/hebertialmeida/ModelGen"
  url "https://github.com/hebertialmeida/ModelGen.git"
      :tag => "0.3.0",
      :revision => "dda61ca457c805514708537a79fe65a5c7856533"
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