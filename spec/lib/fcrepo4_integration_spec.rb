require 'spec_helper'


# These tests require a fedora repository with the resource index enabled (and with syncUpdates = true)
describe "Integration testing against a live Fedora repository", :integration => true do
  REPOSITORY_CONFIG = { :url => "http://localhost:#{ENV['TEST_JETTY_PORT'] || 8080}/rest", :user => 'fedoraAdmin', :password => 'fedoraAdmin' }
  before(:all) do
    @repository = Rubydora.connect REPOSITORY_CONFIG
    @repository.find('test:1').delete rescue nil
  end

  it "should use the multipart api" do
    obj = @repository.find('test:1')
    ds = obj.datastreams['ds1']
    ds.content = '123'

    ds = obj.datastreams['ds2']
    ds.content = '456'

    @repository.should_not_receive(:add_datastream)


    obj.save


    obj = @repository.find('test:1')
    obj.datastreams['ds1'].content.should == '123'
    obj.datastreams['ds2'].content.should == '456'
  end
  
end
