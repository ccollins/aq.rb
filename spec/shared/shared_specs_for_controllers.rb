shared_examples_for "Aquarium Controller" do
  it "should create a url" do
    subject.url.should_not be_nil
  end
  
  describe "#status" do
    it "should respond to status" do
      subject.respond_to?(:status).should be_true
    end
    
    it "should respond to status_fetch_time" do
      subject.respond_to?(:status_fetch_time).should be_true
    end
  end
  
  describe "#fetch_status" do
    it "should respond to fetch_status" do
      subject.respond_to?(:fetch_status).should be_true
    end
    
    it "should set the fetch time" do
      Timecop.freeze(Time.now) do
        subject.expects(:parse_status).returns({})
        subject.stubs(:fetch_url)
        subject.fetch_status
        subject.status_fetch_time.should == Time.now
      end
    end
  end
  
  describe "#build_url" do
    it "should create a proper url" do
      subject.send(:build_url, 'username', 'password', 'host', 80).should =~ /http:\/\/username:password@host:80/
    end
    
    it "should create a url without a username and password" do
      subject.send(:build_url, '', '', 'host', 80).should == 'http://host:80'
    end
  end
  
  describe "#fetch_url" do
    it "should request a url" do
      response = mock
      Net::HTTP.expects(:start).returns(response)
      subject.send(:fetch_url, subject.url, '/status.xml')
    end
  end
end