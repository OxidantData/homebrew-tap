class Oxidant < Formula
  desc "The `oxidant` binary: launches the Spark Connect server and dev utilities."
  homepage "https://github.com/OxidantData/Oxidant"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.1/oxidant-aarch64-apple-darwin.tar.xz"
      sha256 "b973312aea315ce4a5ba228b289b888e539d638c14fd9d5e2e14bbf8f897bd73"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.1/oxidant-x86_64-apple-darwin.tar.xz"
      sha256 "8d69c29b00abd3e7e6aa56eacf7d0adb279814d6c28dc6f59af3df424c6d0d1a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.1/oxidant-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a52df47edc25ab0f09bdbd6ba3e1502e491e5acc1bc5811d00c7889de9a88327"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.1/oxidant-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5bb09ecd39c89ec0e3f37cbb05f7f49db60d85ed72521fa5926ab76ac9ce3cc0"
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
