module Teeworlds
  class MasterServer
    attr_reader :servers

    def initialize
      @servers = []

      1.upto(4) do |num|
        connect_and_request("master#{num}.teeworlds.com", 8300)
      end
    end

    private
    def connect_and_request(server, port)
      udp = UDPSocket.new
      udp.connect(server, port)
      udp.send "\x20\x00\x00\x00\x00\x00\xff\xff\xff\xff\x72\x65\x71\x32", 0

      #loop do
      #  to_read = select([udp], nil, nil, 1)
      #  break if to_read.nil?
      #  parse_servers udp.recvfrom(1400).first
      #end

      Timeout.timeout(1) do
        loop { parse_servers udp.recvfrom(1400).first }
      end
    rescue SocketError, Errno::ECONNREFUSED, Timeout::Error
      udp.close
    end

    def parse_servers(servers_raw)
      servers_raw.bytes[14..-1].each_slice(18) do |s|
        sp = s.pack('C*').unpack('@12C4n')
        @servers.push(ip: sp[0..3].join('.'), port: sp.last)
      end
    end
  end
end
