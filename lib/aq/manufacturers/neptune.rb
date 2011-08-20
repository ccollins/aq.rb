module Neptune  
  def status_page
    'cgi-bin/status.xml'
  end
    
  def parse_status(raw_status)
    parsed_status = Nokogiri::XML raw_status
    aq_status = {:general => read_general(parsed_status), :probes => read_probes(parsed_status), 
                 :outlets => read_outlets(parsed_status), :power => read_power(parsed_status)}
    
    return aq_status
  end
  
  protected
  
  def read_probes(xml)    
    xml.xpath('//probes//probe').map do |probe|
      {:name => probe.at_xpath('name').text, :value => number_or_string(probe.at_xpath('value').text.strip)}
    end
  end
  
  def read_outlets(xml)
    xml.xpath('//outlets//outlet').map do |outlet|
      {:name => outlet.at_xpath('name').text, :state => outlet.at_xpath('state').text.strip}
    end
  end
  
  def read_general(xml)
    general = {}
    general[:hostname] = xml.at_xpath('//hostname').text.strip
    general[:serial] = xml.at_xpath('//serial').text.strip
    general[:date] = Chronic.parse(xml.at_xpath('//date').text.strip)
    
    general
  end
  
  def read_power(xml)
    power = {}
    
    power[:failed] = xml.at_xpath('//power//failed').text.strip
    power[:restored] = xml.at_xpath('//power//restored').text.strip
    
    power
  end
end