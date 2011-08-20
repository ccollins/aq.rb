require 'spec_helper'
require 'aq'

describe Aq::Controllers::Reefkeeper do
  subject { Aq::Controllers::Reefkeeper.new('localhost', 'username', 'password') }
  
  it_behaves_like "Aquarium Controller"
  
  describe "#parse_status" do
    use_vcr_cassette 'Aq_Controllers_Reefkeeper/_parse_status'
    
    before(:each) do
      @status = subject.send(:fetch_url, subject.url, subject.status_page)
    end
    
    it "should populate status hash" do
      subject.parse_status(@status).should_not be_empty
    end
    
    context "status hash" do
      let(:parsed_status) { subject.parse_status(@status) }
      
      it "should have correct general info" do
        parsed_status[:general].should == {:date=>Time.strptime("Mon, 11 Jul 11 14:44:19", "%a, %d %B %y %H:%M:%S")}
      end

      it "should have correct probes" do
        Set.new(parsed_status[:probes]).should == Set.new([{:name=>"SL2: Refugium, ID 07, Temp: Main PMPHTR", :value=>80.7}, {:name=>"SL2: Refugium, ID 07, pH: HTR", :value=>8.17}, {:name=>"PC4: MainPmpsMain PMPHT, ID 02, CH2: HTR", :value=>"OFF"}, {:name=>"PC4: MainPmpsMain PMPHT, ID 02, CH4: ATO", :value=>"OFF"}, {:name=>"PC4: MainLigt16000k, ID 01, Amps", :value=>1.7}, {:name=>"PC4: MainPmpsMain PMPHT, ID 02, Amps", :value=>0.5}, {:name=>"SL1: Breeder, ID 04, Temp: BreedTmpBreedPh", :value=>77.6}, {:name=>"SL1: Breeder, ID 04, pH: BreedPh", :value=>8.22}, {:name=>"SL1: Breeder, ID 04, ORP: BreedORPBreeder", :value=>372}])
      end

      it "should get correct outlets" do
        Set.new(parsed_status[:outlets]).should == Set.new([{:name=>"PC4: MainLigt16000k, ID 01, CH3: 440nm", :state=>"ON"}, {:name=>"PC4: MainLigt16000k, ID 01, CH2: 453nm", :state=>"ON"}, {:name=>"PC4: MainLigt16000k, ID 01, CH1: 16000k", :state=>"ON"}, {:name=>"PC4: MainLigt16000k, ID 01, CH4: Refugium", :state=>"ON"}, {:name=>"PC4: MainPmpsMain PMPHT, ID 02, CH1: Main PMPHTR", :state=>"ON"}, {:name=>"PC4: MainPmpsMain PMPHT, ID 02, CH3: Skimmer", :state=>"ON"}])
      end
    end
  end
end