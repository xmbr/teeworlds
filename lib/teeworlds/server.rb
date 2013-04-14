module Teeworlds
  class Server
    METHODS = [:version, :name, :map, :gametype, :flags, :num_players, :max_players, :num_clients, :max_clients]
    attr_reader :server, :port, :players

    def initialize(arg)
      @server = arg[:server]
      @port = arg[:port] || 8303
      @players = []
    end

    def connect
      Timeout.timeout(1) do
        udp = UDPSocket.new
        udp.connect(@server, @port)
        udp.send("\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x67\x69\x65\x33\x00", 0)
        create_methods udp.recvfrom(1024).first.split("\x00")[1..-1]
      end
    end

    private
    def create_methods(recv)
      self.class.class_eval do
        (0...METHODS.size).each do |num|
          define_method(METHODS[num]) { recv[num] }
        end
      end

      parse_players(recv)
    end

    def parse_players(recv)
      recv[9..-1].each_slice(5) do |player|
        @players.push(
          name: player[0],
          clan: (player[1].empty?) ? nil : player[1],
          country: (player[2] == '-1') ? nil : player[2].to_i,
          score: player[3].to_i,
          playing?: (player[4] == '1') ? true : false
        )
      end
    end
  end
end
