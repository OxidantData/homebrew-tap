class Oxidant < Formula
  desc "The `oxidant` binary: launches the Spark Connect server and dev utilities."
  homepage "https://github.com/OxidantData/Oxidant"
  version "0.1.31"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.31/oxidant-aarch64-apple-darwin.tar.xz"
      sha256 "0f001a6a316f2dc119219111c818d4e7811e4ac5c5ffab11a843b76d8f9a64a5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.31/oxidant-x86_64-apple-darwin.tar.xz"
      sha256 "23dbd5677f5f1673c0af8af2ec376510708c3a54d211155f917b38ba9f6234bf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.31/oxidant-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9e067907b9253e7d8cd556e71be31ca7a4fbbd9bf6d96c5f3db02b28776c4c89"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.31/oxidant-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ceba5da1f37ef4da34a1908df363abd7b3bcfbb2530506fb19ffd6ccb007e764"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "oxidant"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "oxidant"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "oxidant"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "oxidant"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
