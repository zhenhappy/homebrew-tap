class PcapDnsproxy < Formula
  desc "Pcap_DNSProxy, a local DNS server based on WinPcap and LibPcap"
  homepage "https://github.com/chengr28/Pcap_DNSProxy"
  url "https://github.com/chengr28/Pcap_DNSProxy/releases/download/v0.4.9.8/Pcap_DNSProxy-0.4.9.8-bin.zip"
  version "0.4.9.8"
  sha256 "6d7b25b2bc719bac0e37be5ab890f282f1f4cc76470fbcc4e0e5ad49ab11a834"

  def install
    bin.install "macOS/Pcap_DNSProxy"
    (etc/"pcap_dnsproxy").install Dir["macOS/*.{conf,sh,ini,txt}"]
    prefix.install "macOS/pcap_dnsproxy.service.plist"
  end
  
  plist_options :startup => true, :manual => "sudo #{HOMEBREW_PREFIX}/opt/pcap_dnsproxy/bin/Pcap_DNSProxy -c #{HOMEBREW_PREFIX}/etc/pcap_dnsproxy/"

  test do
    (testpath/"pcap_dnsproxy").mkpath
    cp Dir[etc/"pcap_dnsproxy/*"], testpath/"pcap_dnsproxy/"

    inreplace testpath/"pcap_dnsproxy/Config.ini" do |s|
      s.gsub! /^Direct Request.*/, "Direct Request = IPv4 + IPv6"
      s.gsub! /^Operation Mode.*/, "Operation Mode = Proxy"
      s.gsub! /^Listen Port.*/, "Listen Port = 9999"
    end

    pid = fork { exec bin/"Pcap_DNSProxy", "-c", testpath/"pcap_dnsproxy/" }
    begin
      system "dig", "google.com", "@127.0.0.1", "-p", "9999", "+short"
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
