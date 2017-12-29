require 'socket'

module StaticFileServer
  class << self
    def start
      @port = get_free_port
      rd, wt = IO.pipe
      @pid = fork do
        require 'webrick'
        rd.close
        server = WEBrick::HTTPServer.new(
          DocumentRoot: File.expand_path('spec/fixtures/static'),
          Port: @port,
          BindAddress: '127.0.0.1',
          StartCallback: lambda do
            # write "1", signal a server start message
            wt.write(1)
            wt.close
          end
        )
        trap('INT') { server.shutdown }
        server.start
      end
      wt.close
      # read a byte for the server start signal
      rd.read(1)
      rd.close
    end

    def stop
      Process.kill('INT', @pid)
    end

    def url
      "http://localhost:#{@port}"
    end

    def get_free_port
      server = TCPServer.new('127.0.0.1', 0)
      port = server.addr[1]
      server.close
      port
    end
  end
end
