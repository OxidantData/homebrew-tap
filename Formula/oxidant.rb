class Oxidant < Formula
  desc "The `oxidant` binary: launches the Spark Connect server and dev utilities."
  homepage "https://github.com/OxidantData/Oxidant"
  version "0.2.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.2.6/oxidant-aarch64-apple-darwin.tar.xz"
      sha256 "71dae487655db1bec3998fe5321ed5a97b1eb5a86d1e334ad86a393d912e8539"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.2.6/oxidant-x86_64-apple-darwin.tar.xz"
      sha256 "97ef78538ee98e291de525c76ad59fb47011ebcbd6ac66ff43d8b5ebab0f0a4a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.2.6/oxidant-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d39d664f15e483b7799da59708b4385271137f160fdb28c737ff810cad00f9b4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.2.6/oxidant-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "103272d24797f2753a1c90832d668a77475dd3d66280723c04e2594cc71dfd41"
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
