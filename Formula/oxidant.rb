class Oxidant < Formula
  desc "The `oxidant` binary: launches the Spark Connect server and dev utilities."
  homepage "https://github.com/OxidantData/Oxidant"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.1/oxidant-aarch64-apple-darwin.tar.xz"
      sha256 "75bb9a14b1419486859cb26e8a15de7df7aa10d828c203648fa1816cfad932ba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.1/oxidant-x86_64-apple-darwin.tar.xz"
      sha256 "7a82107d95d5862a613f38b18f927dc7ba3a443667b01c0d456c152a22f2cd37"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.1/oxidant-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "435bb64ba09462e34f965885806c0a1fc51534952c228d5ba9d84325e271ac76"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.1/oxidant-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b08f7825ae441b3d6733e03b8920d2d1fc584565f5fa6fa5a08c0dadbd082075"
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
