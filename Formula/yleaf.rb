class Yleaf < Formula
  # cite Raif_2018: "https://doi.org/10.1093/molbev/msy032"
  include Language::Python::Virtualenv

  desc "Human Y-chromosomal haplogroup inference from next generation sequencing data"
  homepage "https://github.com/genid/Yleaf"
  url "https://github.com/genid/Yleaf/archive/refs/tags/3.2.1.tar.gz"
  sha256 "dc288e97c351a3e62093195d27a5fdda0c4ea9e176d66b0adf91eb9bbbf4dfd3"
  license "GPL-3.0-or-later"
  head "https://github.com/genid/Yleaf.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "bcftools"
  depends_on "minimap2"
  depends_on "numpy"
  depends_on "python-setuptools"
  depends_on "python@3.13"
  depends_on "samtools"
  depends_on "six"

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/fa/83/5a40d19b8347f017e417710907f824915fba411a9befd092e52746b63e9f/graphviz-0.20.3.zip"
    sha256 "09d6bc81e6a9fa392e7ba52135a9d49f1ed62526f96499325930e87ca1b5925d"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/fd/1d/06475e1cd5264c0b870ea2cc6fdb3e37177c1e565c43f56ff17a10e3937f/networkx-3.4.2.tar.gz"
    sha256 "307c3669428c5362aab27c8a1260aa8f47c4e91d3891f48be0141738d8d053e1"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/9c/d6/9f8431bacc2e19dca897724cd097b1bb224a6ad5433784a44b587c7c13af/pandas-2.2.3.tar.gz"
    sha256 "4f18ba62b61d7e192368b84517265a99b4d7ee8912f8708660fb4a366cc82667"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f8/bf/abbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aac/pytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/95/32/1a225d6164441be760d75c2c42e2780dc0873fe382da3e98a2e1e48361e5/tzdata-2025.2.tar.gz"
    sha256 "b60a638fcc0daffadf82fe0f57e53d06bdec2f36c4df66280ae79bce6bd6f2b9"
  end

  def install
    venv = virtualenv_install_with_resources

    py_package = venv.site_packages/"yleaf"
    pkgvar = var/"yleaf"
    pkgvar.mkpath
    py_package.install_symlink pkgvar => "data"
    (etc/"yleaf").install_symlink py_package/"config.txt"

    doc.install "README.md"
    doc.install "yleaf_manual.pdf"
  end

  test do
    system "false"
  end
end
