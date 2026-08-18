class Oxidant < Formula
  desc "The `oxidant` binary: launches the Spark Connect server and dev utilities."
  homepage "https://github.com/OxidantData/Oxidant"
  version "0.1.30"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.30/oxidant-aarch64-apple-darwin.tar.xz"
      sha256 "dd367198650b02395553895a515a5d39aae12d5fc1e28523bc452808972c988a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.30/oxidant-x86_64-apple-darwin.tar.xz"
      sha256 "111388c3522034e3eef27c68195bb1a4c652279810223849c3c50a3d03433690"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.30/oxidant-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "49698d43d03caca38a2a85d07560dba1d0510ab96512a2fb03050fee1d0d4b6c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.30/oxidant-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a2b067e09fe6f9e107dce508588dc3486fb59f59907f349cc4dfc834f47d7b92"
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
