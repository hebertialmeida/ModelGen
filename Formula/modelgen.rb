class Modelgen < Formula
  desc "Swift CLI to generate Models based on a JSON Schema and a template."
  homepage "https://github.com/hebertialmeida/ModelGen"
  url "https://github.com/hebertialmeida/ModelGen.git",
      :tag => "0.4.0",
      :revision => "0c691f43f991778110525a27c072eebf907399b1"
  head "https://github.com/hebertialmeida/ModelGen.git"

  depends_on :xcode => ["10.1", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/modelgen", "--version"
  end
end
