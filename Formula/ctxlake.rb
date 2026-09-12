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
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/OxidantData/ctxlake/releases/download/v0.1.7/ctxlake-aarch64-apple-darwin.tar.xz"
      sha256 "3f759a57f4df20c0a7b9aec111086a562d97c942323f484d3f549add7b4359b1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OxidantData/ctxlake/releases/download/v0.1.7/ctxlake-x86_64-apple-darwin.tar.xz"
      sha256 "499c5a9064622d754457c71064876cf702dc439897917ca2c77543c911ac7176"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/OxidantData/ctxlake/releases/download/v0.1.7/ctxlake-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b9ce8a987540afdf340b681ea479f8d32a62d3f238f97d396db59f580adce988"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OxidantData/ctxlake/releases/download/v0.1.7/ctxlake-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "81690ad000309520566d7cb03648463e5126d5413fd7f8929bc38f87c03e730c"
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
