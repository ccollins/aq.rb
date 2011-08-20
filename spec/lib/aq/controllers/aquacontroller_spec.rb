require 'spec_helper'
require 'aq'

describe Aq::Controllers::Aquacontroller do
  subject { Aq::Controllers::Aquacontroller.new('localhost', 'username', 'password') }

  it_behaves_like "Aquarium Controller"
 
  describe "#parse_status" do
    use_vcr_cassette 'Aq_Controllers_Aquacontroller/_parse_status'
    
    before(:each) do
      @status = subject.send(:fetch_url, subject.url, subject.status_page)
    end
    
    it "should populate status hash" do
      subject.parse_status(@status).should_not be_empty
    end
    
    context "status hash" do
      let(:parsed_status) { subject.parse_status(@status) }
      
      it "should have correct general info" do
        parsed_status[:general].should == {:hostname=>"aqua", :serial=>"AC3:02512", :date=>Chronic.parse("07/10/2011 19:54:04")}
      end
      
      it "should have correct power info" do
        parsed_status[:power].should == {:failed=>"none", :restored=>"none"}
      end
      
      it "should have correct probes" do
        Set.new(parsed_status[:probes]).should == Set.new([{:name=>"Temp", :value=>78.0}, {:name=>"pH", :value=>7.95}, {:name=>"ORP", :value=>342}])
      end
      
      it "should get correct outlets" do
        Set.new(parsed_status[:outlets]).should == Set.new([{:name=>"AT5", :state=>"AON"}, {:name=>"MH1", :state=>"OFF"}, {:name=>"HET", :state=>"AOF"}, {:name=>"WAV", :state=>"AON"}, {:name=>"RTN", :state=>"AON"}, {:name=>"SKM", :state=>"AON"}, {:name=>"ECS", :state=>"AON"}, {:name=>"ECM", :state=>"AON"}, {:name=>"ALM", :state=>"AOF"}, {:name=>"MON", :state=>"AON"}])
      end
    end
  end
end