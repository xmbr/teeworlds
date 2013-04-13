require 'spec_helper'

describe Teeworlds::MasterServer do
  before do
    master_5_servers = [File.open('spec/fixtures/master_5_servers', 'r:ASCII-8BIT').read]
    @socket_mock = mock
    @socket_mock.should_receive(:connect).exactly(4).times
    @socket_mock.should_receive(:send).exactly(4).times
    @socket_mock.should_receive(:recvfrom).and_return(master_5_servers)
    @socket_mock.should_receive(:recvfrom).at_least(3).times.and_return(['.' * 14])
    @socket_mock.should_receive(:close).exactly(4).times
    UDPSocket.stub(new: @socket_mock)
  end

  describe '.new' do
    it 'should connect to masterservers 1-4' do
      Teeworlds::MasterServer.new
    end
  end

  describe '#servers' do
    it 'should return 5 servers' do
      ms = Teeworlds::MasterServer.new

      ms.servers.should == [
        { ip: '88.198.182.255', port: 9123 },
        { ip: '109.73.50.121',  port: 9016 },
        { ip: '46.38.237.106',  port: 8308 },
        { ip: '188.233.98.250', port: 8303 },
        { ip: '217.29.118.189', port: 8202 }
      ]
    end
  end
end

describe Teeworlds::ServerStatus do
  context 'when connection failed' do
    it 'raises Errno::ECONNREFUSED if could not connect to server' do
      expect { Teeworlds::ServerStatus.new('127.0.0.1', 6666) }.to raise_error(Errno::ECONNREFUSED)
    end
  end

  context 'when connection succeeded' do
    before do
      server_3_players = [File.open('spec/fixtures/server_3_players', 'r:ASCII-8BIT').read]
      @socket_mock = mock
      @socket_mock.should_receive(:send).with("\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x67\x69\x65\x33\x00", 0)
      @socket_mock.should_receive(:recvfrom).and_return(server_3_players)
      UDPSocket.stub(new: @socket_mock)
      #UDPSocket.should_receive(:new).and_return(@socket_mock)
    end

    let(:tw_server) { Teeworlds::ServerStatus.new('127.0.0.1', 8500) }
    let(:tw_server_no_port) { Teeworlds::ServerStatus.new('127.0.0.1') }

    describe '.new' do
      it 'should connect to requested server and port' do
        @socket_mock.should_receive(:connect).with('127.0.0.1', 8500)
        tw_server
      end

      it "should connect to default port if none is given" do
        @socket_mock.should_receive(:connect).with('127.0.0.1', 8303)
        tw_server_no_port
      end
    end

    describe 'instance method' do
      before { @socket_mock.should_receive(:connect).with('127.0.0.1', 8500) }
      subject { tw_server }

      describe '#version' do
        it { should respond_to(:version) }
        it 'equals "0.6 trunk, 1.14a"' do
          subject.version.should eql '0.6 trunk, 1.14a'
        end
      end

      describe '#name' do
        it { should respond_to(:name) }
        it 'equals "FS Server"' do
          subject.name.should eql 'FS Server'
        end
      end

      describe '#map' do
        it { should respond_to(:map) }
        it 'equals "xyz_ddrace2"' do
          subject.map.should eql 'xyz_ddrace2'
        end
      end

      describe '#gametype' do
        it { should respond_to(:gametype) }
        it 'equals "DDRace"' do
          subject.gametype.should eql 'DDRace'
        end
      end

      describe '#flags' do
        it { should respond_to(:flags) }
        it 'equals "0"' do
          subject.flags.should eql '0'
        end
      end

      describe '#num_players' do
        it { should respond_to(:num_players) }
        it 'equals "3"' do
          subject.num_players.should eql '3'
        end
      end

      describe '#max_players' do
        it { should respond_to(:max_players) }
        it 'equals "15"' do
          subject.max_players.should eql '15'
        end
      end

      describe '#num_clients' do
        it { should respond_to(:num_clients) }
        it 'equals "3"' do
          subject.num_clients.should eql '3'
        end
      end

      describe '#max_clients' do
        it { should respond_to(:max_clients) }
        it 'equals "15"' do
          subject.max_clients.should eql '15'
        end
      end

      describe '#players' do
        it { should respond_to(:players) }

        it 'returns an array' do
          subject.players.should be_an(Array)
        end

        it 'has 3 elements' do
          subject.players.should have(3).items
        end

        it 'is an array of hashes with name, clan, country, score and playing keys' do
          subject.players[0].should == {
            name: 'Jules',
            clan: 'Gangsta',
            country: 616,
            score: -9999,
            playing?: true
          }

          subject.players[1].should == {
            name: 'Vincent',
            clan: 'Gangsta',
            country: 276,
            score: -9999,
            playing?: false
          }

          subject.players[2].should == {
            name: 'Butch',
            clan: 'Boxer',
            country: nil,
            score: -9999,
            playing?: true
          }
        end
      end
    end
  end
end
