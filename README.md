# Teeworlds

Teeworlds is a multiplayer shooter. This gem allows you to fetch all available game servers and view current status of each.

## Installation

Add this line to your application's Gemfile:

    gem 'teeworlds'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install teeworlds

## Usage

    ms = Teeworlds::MasterServer.new

    ms.servers.each do |tw|
      puts "#{tw.server}: #{tw.port}"
    end

    s = ms.servers.first
    s.connect

    puts "Server name: #{s.name}, map: #{s.map}, type: #{s.gametype}"
    puts "Num clients: #{s.num_clients}"
    puts "Max clients: #{s.max_clients}"
    puts "Num player: #{s.num_players}"
    puts "Max player: #{s.max_players}"

    s.players.each { |player| puts player }

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
