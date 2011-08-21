module Aq
  module Controllers
    class Aquatronica < Aq::Controller
      TIMER_BITMASK = 0x80
      STATUS_BITMASK = 0x7F
      MANUAL = 120
    
      def status_page
        'rtMon.xml'
      end
  
      def parse_status(raw_status)
        parsed_status = Nokogiri::XML raw_status
        aq_status = {:general => read_general(parsed_status), :probes => read_probes(parsed_status), 
                     :outlets => read_outlets(parsed_status), :power => {}}
    
        return aq_status
      end
  
      def on? outlet
        outlet.to_i & TIMER_BITMASK != 0
      end
  
      def manual? outlet
        outlet.to_i & STATUS_BITMASK == MANUAL
      end
  
      protected
  
      def read_general(xml)
        {:date => status_fetch_time}
      end
  
      def read_probes(xml)    
        xml.xpath('//sensorList//sensor').map do |sensor|
          value = sensor.at_xpath('value').text.scan(/[[:digit:]]|[[:punct:]]/).join.strip
          {:name => sensor.at_xpath('name').text.strip, :value => number_or_string(value)}
        end
      end
  
      def read_outlets(xml)
        xml.xpath('//plugList//plug').map do |plug|
          {:name => plug.at_xpath('name').text.strip, :state => number_or_string(plug.at_xpath('status').text.strip)}
        end
      end
    end
  end
end