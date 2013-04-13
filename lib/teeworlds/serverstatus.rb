module Teeworlds
  class ServerStatus
    METHODS = [:version, :name, :map, :gametype, :flags, :num_players, :max_players, :num_clients, :max_clients]
    attr_reader :players

    def initialize(server, port = 8303)
      @server, @port, @players = server, port, []
      @recv = Timeout.timeout(1) { connect_and_request }
      #@recv = connect_and_request
      parse_players
    end

    (0...METHODS.size).each do |num|
      define_method METHODS[num] do
        @recv[num]
      end
    end

    private
    def connect_and_request
      udp = UDPSocket.new
      udp.connect(@server, @port)
      udp.send("\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x67\x69\x65\x33\x00", 0)
      #raise "Can't receive from server." unless select([udp], nil, nil, 1)
      udp.recvfrom(1024).first.split("\x00")[1..-1]
    end

    def parse_players
      @recv[9..-1].each_slice(5) do |player|
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
