class Iqtree2 < Formula
  # cite Nguyen_2015: "https://doi.org/10.1093/molbev/msu300"
  desc "Efficient phylogenomic software by maximum likelihood"
  homepage "http://www.iqtree.org/"
  # pull from git tag to get submodules
  url "https://github.com/iqtree/iqtree2.git",
    tag:      "v.2.3.3",
    revision: "dbd102a38662f6d2337f40b0064e26c6a6b3d3b0"
  license "GPL-2.0-only"
  head "https://github.com/iqtree/iqtree2.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, catalina:     "b9d0f98622e3223771bbdd6c86861a37d240dfa9bdc357888b589802b0eb8056"
    sha256 cellar: :any, x86_64_linux: "06d8c6b11ddb0b991ed2b1e237a4c900be94a632dc4ba4deb442a241dbf4f996"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "gsl"   => :build
  depends_on "libomp" if OS.mac?
  depends_on "llvm" if OS.mac?
  uses_from_macos "zlib"

  def install
    mkdir "build" do
      ENV.append_path "PREFIX_PATH", buildpath/"lsd2"
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "boot", shell_output("#{bin}/iqtree2 -h 2>&1")
    assert_match version.to_s, shell_output("#{bin}/iqtree2 --version")
  end
end
