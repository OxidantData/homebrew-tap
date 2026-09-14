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
  version "0.1.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/OxidantData/ctxlake/releases/download/v0.1.11/ctxlake-aarch64-apple-darwin.tar.xz"
      sha256 "4a70c1fd1fc5b864545e73313dd576afd1eff0bbfcb0ed4e1230dae35a589afe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OxidantData/ctxlake/releases/download/v0.1.11/ctxlake-x86_64-apple-darwin.tar.xz"
      sha256 "702fa4b4b1f43d47b38277c782e781d36ba684c095b4a8d6775f86339cd0ae81"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/OxidantData/ctxlake/releases/download/v0.1.11/ctxlake-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1f0ef7c4328e4ea9eb998ffc9031512383aa176d28043ef45175d6bb2bfc3bd5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OxidantData/ctxlake/releases/download/v0.1.11/ctxlake-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e1fda277dc508a71e7d852954a23f128ad63b5764c5d2347c226c9f0383b3395"
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
