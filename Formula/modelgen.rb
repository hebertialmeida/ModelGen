class Modelgen < Formula
  desc "Swift CLI to generate Models based on a JSON Schema and a template."
  homepage "https://github.com/hebertialmeida/ModelGen"
  url "https://github.com/hebertialmeida/ModelGen.git",
      :tag => "0.4.0",
      :revision => "22ca2343cd65a4df4a039eef004ba5a75a0609fc"
  head "https://github.com/hebertialmeida/ModelGen.git"

  depends_on :xcode => ["9.3", :build]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc", "-static-stdlib"
    bin.install ".build/release/modelgen"
    lib.install Dir[".build/release/*.dylib"]
  end

  test do
    system bin/"modelgen", "--version"
  end
end