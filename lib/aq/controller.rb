module Aq
  class Controller
    attr_accessor :url, :status, :status_fetch_time
  
    def initialize(host, user='', password='', port=80)
      @url ||= build_url(user, password, host, port)
    end
    
    def fetch_status
      @status_fetch_time = Time.now
      status = parse_status(fetch_url(url, status_page))
    end
  
    def status
      @status || fetch_status
    end
    
    def on? outlet
      outlet.include?("ON")
    end
    
    def manual?
      false
    end
  
    def number_or_string(value)
      if value.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) 
        value.to_s.match(/\./) ? Float(value) : Integer(value)
      else
        value
      end
    end
    
    protected
    
    def build_url(user, password, host, port)
      if !user.nil? && !user.empty? && !password.nil? && !password.empty?
        "http://#{user}:#{password}@#{host}:#{port.to_s}"
      else
        "http://#{host}:#{port.to_s}"
      end
    end
    
    def fetch_url url, page
      url = URI.parse(url)
      Net::HTTP.start(url.host, url.port) do |http|
        req = Net::HTTP::Get.new("/#{page}")
        req.basic_auth url.user, url.password
        response = http.request(req)

        case response
        when Net::HTTPSuccess then response.body
        else
          raise Exception.new(response.error!)
        end
      end
    end
  end
end