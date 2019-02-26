class Modelgen < Formula
  desc "Swift CLI to generate Models based on a JSON Schema and a template."
  homepage "https://github.com/hebertialmeida/ModelGen"
  url "https://github.com/hebertialmeida/ModelGen.git", 
    :tag => "0.4.0",
    :revision => "5d4bb5ab8d8ba95098c8326ae1641e03e521ed3d"
  head "https://github.com/hebertialmeida/ModelGen.git"

  depends_on :xcode => ["10.1", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/modelgen", "--version"
  end
end
