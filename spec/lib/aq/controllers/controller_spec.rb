require 'spec_helper'
require 'aq'

describe Aq::Controller do
  subject { Aq::Controller.new('localhost', 'username', 'password') }
  
  before(:each) do
    subject.stubs(:status_page).returns('')
  end
  
  it_behaves_like "Aquarium Controller"
end