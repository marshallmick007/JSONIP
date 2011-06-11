require 'net/http'
require 'json'

class JSONIP
    attr_accessor :verbose, :url

    def initialize(verbose, url='jsonip.com')
        @verbose = verbose
        @url = url
    end

    def fetch
        url = @url
        log "Fetching IP address in json format from #{url}"
        begin
            h = Net::HTTP.new(@url, 80)

            ##resp, data = h.get('/', nil)
            h.get('/') do |resp| 
                log "Response: #{resp}"
                parsed = JSON.parse resp
                out parsed["ip"]
            end
        rescue SocketError => sockex
            log "Network Error while fetching IP from #{url}"
            log sockex
            out "Unknown IP"
        rescue StandardError => ex
            log "Error while fetching IP"
            log "Exception type: " + ex.class 
            log ex
            out "Unknown IP"
        #out data
        end 
    end

    def log(msg)
        if @verbose
            puts msg
        end
    end

    def out(msg)
        puts msg
    end
end

## Main
#puts 'jsonip v0.1'

verbose = (ARGV[0] || '') == '-v'

j = JSONIP.new(verbose)
j.fetch

