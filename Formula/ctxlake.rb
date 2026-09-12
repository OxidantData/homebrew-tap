# Homebrew formula TEMPLATE for ctxlake.
#
# This is not consumed by Homebrew directly — it is filled in by
# `packaging/render-formula.sh` (called from .github/workflows/release.yml's
# `release` job, after the four target archives and their checksums exist) and
# the *rendered* file is attached to the GitHub Release as `ctxlake.rb`.
#
# OxidantData/homebrew-tap pulls that asset itself, hourly, via its own
# `sync-formulae` workflow — the tap writes only to itself and reads only public
# releases, so nothing here needs a token scoped to another repo.
#
# This used to say the copy was a manual step, "deliberately", on the reasoning
# that a cross-repo push token outweighed saving one `cp`. The reasoning was fine
# and the outcome was not: the `cp` never happened for any release, so
# `brew install oxidantdata/tap/ctxlake` failed for every user while the docs
# advertised it. A documented step nobody runs is worse than an automated one,
# because everyone downstream assumes it ran.
#
# Shape matches ../../homebrew-tap/Formula/oxidant.rb (the house style: one
# `if OS.mac? / if Hardware::CPU.arm?` branch per platform+arch, not a loop) —
# ctxlake ships two binaries per archive (`ctxlake`, `ctxlake-hook`) where
# Oxidant ships one, so `install` lists both.
class Ctxlake < Formula
  desc "Zero-compute coordination layer for fleets of coding agents: ctxlake and ctxlake-hook"
  homepage "https://github.com/OxidantData/ctxlake"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/OxidantData/ctxlake/releases/download/v0.1.8/ctxlake-aarch64-apple-darwin.tar.xz"
      sha256 "2b5a9387c256b949555efdd379129938adf16b929a4ef52676862259a2231aaa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OxidantData/ctxlake/releases/download/v0.1.8/ctxlake-x86_64-apple-darwin.tar.xz"
      sha256 "12fc4c52f0472d3001dd7227c756fb530527ac271bfcb2acf1a618a88722d6c2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/OxidantData/ctxlake/releases/download/v0.1.8/ctxlake-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c919a6d861e2bd008e2124a075745ea2bd7f1d2b494c5ee1a875b7a7fcf64106"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OxidantData/ctxlake/releases/download/v0.1.8/ctxlake-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "22e483e6bd8457a09f711fdb7c132f5c33e13a8b9c6cbcdabd31098f66b5990f"
    end
  end
  license "AGPL-3.0-or-later"

  def install
    bin.install "ctxlake"
    bin.install "ctxlake-hook"

    # Homebrew installs these automatically from the prefix; ship whatever the
    # archive happens to carry without failing when one is absent (a source
    # checkout always has them, but keep this robust to what the archive step
    # decides to include).
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "NOTICE", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files - ["ctxlake", "ctxlake-hook"]
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end

  test do
    system "#{bin}/ctxlake", "--version"
  end
end
