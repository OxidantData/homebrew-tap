class Oxidant < Formula
  desc "The `oxidant` binary: launches the Spark Connect server and dev utilities."
  homepage "https://github.com/OxidantData/Oxidant"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.0/oxidant-aarch64-apple-darwin.tar.xz"
      sha256 "919d93bc71309b206cb844418b84812ed770fb39b7a2f8036227dbdad52e9233"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.0/oxidant-x86_64-apple-darwin.tar.xz"
      sha256 "ec3951fe63f0e6b623f815c7adaadd7eebdbe9812ebb8d063428af5dffcfc663"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.0/oxidant-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fa63dbf6a43c3f500fd0728e0ae83d5a9557aa52d8a2025e0d45d8a9707a320d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.0/oxidant-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e226ca91f635d32f6fdef5ebe6f9b7e1526577b2458578cf36a6b1032523bb77"
    end
  end
  license "AGPL-3.0-or-later"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "oxidant" if OS.mac? && Hardware::CPU.arm?
    bin.install "oxidant" if OS.mac? && Hardware::CPU.intel?
    bin.install "oxidant" if OS.linux? && Hardware::CPU.arm?
    bin.install "oxidant" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
