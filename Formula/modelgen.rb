class Modelgen < Formula
  desc "Swift CLI to generate Models based on a JSON Schema and a template."
  homepage "https://github.com/hebertialmeida/ModelGen"
  url "https://github.com/hebertialmeida/ModelGen.git", 
    :tag => "0.5.0",
    :revision => "af78ff30926722ac381950704bef53495f517d05"
  head "https://github.com/hebertialmeida/ModelGen.git"

  depends_on :xcode => ["10.1", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/modelgen", "--version"
  end
end
