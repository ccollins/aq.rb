require 'spec_helper'
require 'aq'

describe Aq::Controllers::Aquatronica do
  subject { Aq::Controllers::Aquatronica.new('localhost', 'username', 'password') }

  it_behaves_like "Aquarium Controller"
  
  describe "#parse_status" do
    use_vcr_cassette 'Aq_Controllers_Aquatronica/_parse_status'
    
    before(:each) do
      @status = subject.send(:fetch_url, subject.url, subject.status_page)
      subject.status_fetch_time = Time.now
    end
  
    it "should populate status hash" do
      subject.parse_status(@status).should_not be_empty
    end
  
    context "status hash" do
      let(:parsed_status) { subject.parse_status(@status) }
    
      it "should have correct general info" do
        parsed_status[:general].should == {:date=>subject.status_fetch_time}
      end

      it "should have correct probes" do
        Set.new(parsed_status[:probes]).should == Set.new([{:name=>"Temp - Tank", :value=>25.4}, {:name=>"Temp - Quar", :value=>25.4}, {:name=>"Level", :value=>""}, {:name=>"Redox", :value=>261}, {:name=>"pH", :value=>8.04}])
      end
    
      it "should get correct outlets" do
        Set.new(parsed_status[:outlets]).should == Set.new([{:name=>"A", :state=>0}, {:name=>"Reef Brite", :state=>138}, {:name=>"C", :state=>0}, {:name=>"F-Sump Heater", :state=>0}, {:name=>"E", :state=>0}, {:name=>"Fan - Sump", :state=>0}, {:name=>"G", :state=>0}, {:name=>"Ethernet Power", :state=>138}, {:name=>"Red Dragon 8.3m", :state=>138}, {:name=>"D", :state=>138}, {:name=>"B-Sump Heater", :state=>0}, {:name=>"F", :state=>0}, {:name=>"Quar - Heater", :state=>0}])
      end
    end
  end
end