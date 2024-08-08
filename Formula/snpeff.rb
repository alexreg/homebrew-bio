class Snpeff < Formula
  # cite Cingolani_2012: "https://doi.org/10.4161/fly.19695"
  desc "Genetic variant annotation and effect prediction toolbox"
  homepage "https://snpeff.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/snpeff/snpEff_v4_3t_core.zip"
  version "4.3t"
  sha256 "d55a7389a78312947c1e7dadf5e6897b42d3c6e942e7c1b8ec68bb35d2ae2244"

  livecheck do
    url "https://sourceforge.net/projects/snpeff/files/"
    strategy :page_match
    regex(/href=.*?snpEff[._-]v?(\d+(?:[._-]\d+)+[a-z]?)[._-]core\.zip/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "00eec264d4fc0b2580e05e8c193e03a1e4390882007b010f22d9b29601274051"
    sha256 cellar: :any_skip_relocation, ventura:      "00eec264d4fc0b2580e05e8c193e03a1e4390882007b010f22d9b29601274051"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c2ef3288fd929d83ea39c33c68a4f4354cdf265e3e7f3b9f8c6fb4a2be348c4e"
  end

  depends_on "openjdk@11"

  def install
    # snpEff and SnpSift
    cd "snpEff" do
      inreplace "scripts/snpEff" do |s|
        s.gsub!(/^jardir=.*/, "jardir=#{libexec}")
        s.gsub! "${jardir}/snpEff.config", "#{pkgshare}/snpEff.config"
      end
      bin.install "scripts/snpEff"
      libexec.install "snpEff.jar", "SnpSift.jar"
      bin.write_jar_script libexec/"SnpSift.jar", "SnpSift"
      pkgshare.install "snpEff.config", "scripts", "galaxy", "examples"
    end

    # ClinEff
    cd "clinEff" do
      libexec.install "ClinEff.jar"
      bin.write_jar_script libexec/"ClinEff.jar", "ClinEff"
      pkgshare.install "workflow", "report"
    end
  end

  def caveats
    <<~EOS
      Download the human database using the command
        snpEff download -v GRCh38.82
      The databases will be installed in #{pkgshare}/data
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snpEff -version 2>&1")
    assert_match "Concordance", shell_output("#{bin}/SnpSift 2>&1", 1)
    assert_match "annotations", shell_output("#{bin}/ClinEff -h 2>&1", 255)
  end
end
