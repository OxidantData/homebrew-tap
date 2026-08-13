class Oxidant < Formula
  desc "The `oxidant` binary: launches the Spark Connect server and dev utilities."
  homepage "https://github.com/OxidantData/Oxidant"
  version "0.1.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.13/oxidant-aarch64-apple-darwin.tar.xz"
      sha256 "dc053d245b3f770ecd5cd218682aee2fc1143a387e52b98db784775fd1b8736f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.13/oxidant-x86_64-apple-darwin.tar.xz"
      sha256 "fe2e550e5ca9b0ae6464bdce07f1294183160efb94a0a094fc1e40f7591ba990"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.13/oxidant-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5508e0e9fc5037236569abfc7a43540d580def0402e8741e512cf323745730a6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.13/oxidant-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4675c69c24cc74f720a1fdaddf488c46b3216bcdd2725c3407729c9d5470fdee"
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
