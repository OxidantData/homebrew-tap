class Oxidant < Formula
  desc "The `oxidant` binary: launches the Spark Connect server and dev utilities."
  homepage "https://github.com/OxidantData/Oxidant"
  version "0.1.23"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.23/oxidant-aarch64-apple-darwin.tar.xz"
      sha256 "5d483505c87ca0965c41267ccc6358b048562af8bbc184fd376743e71238b279"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.23/oxidant-x86_64-apple-darwin.tar.xz"
      sha256 "fd2d3edc47c42acb7a1f5b91ddb4f4b2340969bf1c7287d6c235429c65123474"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.23/oxidant-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8d88b8267e80b393fe68e38320f001e0888c52babac1168e6d2da0bf5b164e50"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OxidantData/Oxidant/releases/download/v0.1.23/oxidant-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "30c644bf3410ab8d1663166135ffed0f35e3cde64049944998bca75632bb5160"
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
