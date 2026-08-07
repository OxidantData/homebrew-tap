class Oxidant < Formula
  desc "The `oxidant` binary: launches the Spark Connect server and dev utilities."
  homepage "https://github.com/OxidantData/Oxidant"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.0/oxidant-aarch64-apple-darwin.tar.xz"
      sha256 "ce66cf835b45941282994dbed089e3167c83295e68c5244b0bb9e346500c0c12"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.0/oxidant-x86_64-apple-darwin.tar.xz"
      sha256 "f72cca28cde1639d6419ad38f9510c15673566a92100b861d0a54b42bf00c22c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.0/oxidant-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cb1169ebd79222871da0618cf26877588f12be5b64dd27cda6009c778b2e4b04"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.0/oxidant-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b86c1aba180d9c9e802bf59a9b505549f5d47714fdd3aad3567f00f06da822fd"
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
