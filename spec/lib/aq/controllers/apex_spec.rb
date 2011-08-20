require 'spec_helper'
require 'aq'

describe Aq::Controllers::Apex do
  subject { Aq::Controllers::Apex.new('localhost', 'username', 'password') }
  
  it_behaves_like "Aquarium Controller"
  
  describe "#parse_status" do
    use_vcr_cassette 'Aq_Controllers_Apex/_parse_status'
    
    before(:each) do
      @status = subject.send(:fetch_url, subject.url, subject.status_page)
    end
    
    it "should populate status hash" do
      subject.parse_status(@status).should_not be_empty
    end
    
    context "status hash" do
      let(:parsed_status) { subject.parse_status(@status) }
      
      it "should have correct general info" do
        parsed_status[:general].should == {:hostname=>"SaltCube", :serial=>"AC4:06126", :date=>Chronic.parse("07/11/2011 15:06:58")}
      end
      
      it "should have correct power info" do
        parsed_status[:power].should == {:failed=>"06/17/2011 11:31:21", :restored=>"06/17/2011 11:32:12"}
      end
      
      it "should have correct probes" do
        Set.new(parsed_status[:probes]).should == Set.new([{:name=>"Temp", :value=>77.8}, {:name=>"pH", :value=>7.84}, {:name=>"ORP", :value=>0}, {:name=>"Amp_3", :value=>3.0}])
      end
      
      it "should get correct outlets" do
        Set.new(parsed_status[:outlets]).should == Set.new([{:name=>"VarSpd1_I1", :state=>"Lil4"}, {:name=>"VarSpd2_I2", :state=>"Lil3"}, {:name=>"VarSpd3_I3", :state=>"Big1"}, {:name=>"VarSpd4_I4", :state=>"Big2"}, {:name=>"SndAlm_I6", :state=>"OFF"}, {:name=>"SndWrn_I7", :state=>"OFF"}, {:name=>"EmailAlm_I5", :state=>"AOF"}, {:name=>"Light1_3_1", :state=>"AOF"}, {:name=>"Light2_3_2", :state=>"AON"}, {:name=>"Pump1_3_3", :state=>"ON"}, {:name=>"Pump2_3_4", :state=>"ON"}, {:name=>"Heater_3_5", :state=>"AOF"}, {:name=>"Chiller_3_6", :state=>"ON"}, {:name=>"CO2_3_7", :state=>"AOF"}, {:name=>"Ozone_3_8", :state=>"ON"}])
      end
    end
  end
end