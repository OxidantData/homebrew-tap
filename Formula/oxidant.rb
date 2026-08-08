class Oxidant < Formula
  desc "The `oxidant` binary: launches the Spark Connect server and dev utilities."
  homepage "https://github.com/OxidantData/Oxidant"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.2/oxidant-aarch64-apple-darwin.tar.xz"
      sha256 "11d610a718b44a6ade72d6973ea6fe9728d94b684275b4bff1a0720c058c159b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.2/oxidant-x86_64-apple-darwin.tar.xz"
      sha256 "6b66be3096502e46fc281f33498ac54f65e8c063fe6a85c3a195caccf9b084a6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.2/oxidant-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "742c936de3c7d2cfbef57c739af4ed260d886ff31488a8c495ac42ecc465b045"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.2/oxidant-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "92160f94ead66ec15efb730537bf54fac42b079196519d04db6211e1cb4aaf1e"
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
