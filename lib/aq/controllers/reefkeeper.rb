class Aq::Controllers::Reefkeeper < Aq::Controller
  def status_page
    'rss/rss.xml'
  end
    
  def parse_status(raw_status)
    parsed_status = Nokogiri::XML raw_status
    aq_status = {:general => read_general(parsed_status), :power => {}}.merge(read_outlets_and_probes(parsed_status))
    
    return aq_status
  end
  
  protected
  
  def read_outlets_and_probes(xml)
    o_and_ps = {:probes => [], :outlets => []}
    
    xml.xpath('//item').each do |o_or_p|
      if outlet? o_or_p
        o_and_ps[:outlets].push({:name => o_or_p.at_xpath('title').text.strip, :state => clean_value(o_or_p.at_xpath('description').text)})
      else
        o_and_ps[:probes].push({:name => o_or_p.at_xpath('title').text.strip, :value => number_or_string(clean_value(o_or_p.at_xpath('description').text))})
      end
    end  
    
    o_and_ps 
  end
  
  def outlet? node
    node.at_xpath('description').text.include? ": ON"
  end
  
  def clean_value value
    value.strip!.gsub!(/Current Value: /, '')
    (value.match /ON|OFF/) ? value : value.scan(/[[:digit:]]|[[:punct:]]/).join.strip
  end
  
  def read_general(xml)
    {:date => Time.strptime(xml.xpath('//pubDate').first.text.strip, "%a, %d %B %y %H:%M:%S")}
  end
end