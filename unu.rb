class unu < Formula
  desc "U.NU is a free URL Shortener Service."
  homepage "https://u.nu"
  url "https://u.nu/unu"
  version "0.0.1"
  sha256 "1bad62f7d634628656c00c795663aa88a991a105beef9c898828128dc6fe470a"

  def install
    bin.install "unu"
  end
end
