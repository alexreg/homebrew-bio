class Plink2 < Formula
  # cite Chang_2015: "https://doi.org/10.1186/s13742-015-0047-8"
  desc "Analyze genotype and phenotype data"
  homepage "https://www.cog-genomics.org/plink2"
  url "https://github.com/chrchang/plink-ng/archive/refs/tags/v2.00a5.10.tar.gz"
  version "2.00a5"
  sha256 "53d845c6a04f8fc701e6f58f6431654e36cbf6b79bff25099862d169a8199a45"
  head "https://github.com/chrchang/plink-ng.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, catalina:     "5c6ac77111c1eeeab30af40e8a1c14391a182a10e2535f9ebe0a58ee62f70828"
    sha256 cellar: :any, x86_64_linux: "23f851b712db8ddf8e5587623b12599833c288aca026fa4790ee5384f0a870ba"
  end

  depends_on "openblas"
  uses_from_macos "zlib"
  # depends_on "zlib"

  def install
    cd "2.0" do
      system "make", "install",
        "BLASFLAGS=-L#{Formula["openblas"].opt_lib} -lopenblas",
        "CFLAGS=-flax-vector-conversions",
        "CPPFLAGS=-DDYNAMIC_ZLIB -I#{Formula["openblas"].opt_include}",
        "ZLIB=-L#{Formula["zlib"].opt_lib} -lz",
        "DESTDIR=#{prefix}",
        "PREFIX="
    end
  end

  test do
    system "#{bin}/plink2", "--dummy", "513", "1423", "0.02", "--out", "dummy_cc1"
    assert_predicate testpath/"dummy_cc1.pgen", :exist?
  end
end
