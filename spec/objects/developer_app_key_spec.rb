require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe 'DeveloperAppKey' do 
  before :all do 
    @app_name = 'testapp'
    @developer_email = 'sampledev@example.com'
    @developer_id    = 'F1bPGroWVtO9PATt'
    @apiproduct_name = 'myapiproduct'
    @new_apiproduct_name = 'mytest'
    @consumer_key    = 'OOdAwgpyifxXPUeMDGKJBqDDDfDK12AS'
    @credentials = [
      {
        "apiProducts"     => [{"apiproduct" => @apiproduct_name, "status" => "approved"}], 
        "attributes"      => [], 
        "consumerKey"     => @consumer_key, 
        "consumerSecret"  => "lkECj1mAUzfBmdtD", 
        "scopes"          => [], 
        "status"          => "approved"
      }
    ]
    @app = {
      :name         => @app_name,
      :appId        => '35eaba24-c340-48a2-819e-34d81993f9ab',
      :developerId  => @developer_id,

      :accessType     => "read", 
      :appFamily      => "default", 
      :attributes     => [{"name"=>"Developer", "value"=>@developer_email}, {"name"=>"DisplayName", "value"=>@app_name}, {"name"=>"Notes", "value"=>""}, {"name"=>"lastModifier", "value"=>""}], 
      :callbackUrl    => "http://example.com", 
      :createdAt      => 1369488501956, 
      :createdBy      => "adminui@apigee.com", 
      :credentials    => @credentials, 
      :lastModifiedAt => 1369555151917, 
      :lastModifiedBy => @developer_email, 
      :scopes         => [], 
      :status         => "approved"
    }

    ActiveResource::HttpMock.respond_to do |mock|
      org = ApigeePlatform::Objects::Base.config[:organization]
      mock.get "/v1/o/#{org}/developers/#{@developer_id}/apps/#{@app_name}", GET_HEADERS, @app.to_json
      mock.post "/v1/o/#{org}/developers/#{@developer_id}/apps/#{@app_name}/keys/#{@consumer_key}", POST_HEADERS, {"apiProducts"=>["smtp_public_api", @new_apiproduct_name]}.to_json
      mock.post "/v1/o/#{org}/developers/#{@developer_id}/apps/#{@app_name}/keys/#{@consumer_key}/apiproducts/mytest?action=approve", NO_CONTENT_HEADERS, nil, 204
      mock.post "/v1/o/#{org}/developers/#{@developer_id}/apps/#{@app_name}/keys/#{@consumer_key}/apiproducts/mytest?action=revoke", NO_CONTENT_HEADERS, nil, 204
      mock.delete "/v1/o/#{org}/developers/#{@developer_id}/apps/#{@app_name}/keys/#{@consumer_key}/apiproducts/mytest", GET_HEADERS, nil, 204
    end
  end

  subject { ApigeePlatform::Objects::DeveloperApp.find(@app_name, :params => {:developer_id => @developer_id}) }

  it 'has keys' do 
    subject.should respond_to(:keys)
  end

  describe 'Key' do 
    subject { ApigeePlatform::Objects::DeveloperApp.find(@app_name, :params => {:developer_id => @developer_id}).keys.first }
    it 'has api products from nested credentials' do
      subject.apiproducts[@credentials.first['apiProducts'].first['apiproduct']].should == @credentials.first['apiProducts'].first['status']
    end

    it 'can add product' do 
      subject.should respond_to(:add_product)
    end

    it 'can approve product' do 
      subject.should respond_to(:approve_product)
    end

    it 'can revoke product' do 
      subject.should respond_to(:revoke_product)
    end

    it 'can remove product' do 
      subject.should respond_to(:remove_product)
    end

    it 'saves new product' do 
      subject.add_product(@new_apiproduct_name)
      subject.apiproducts[@new_apiproduct_name].should be_present
    end

    it 'saves new product' do 
      subject.add_product(@new_apiproduct_name)
      subject.apiproducts[@new_apiproduct_name].should be_present
    end

    it 'approves product' do 
      subject.add_product(@new_apiproduct_name)
      subject.approve_product(@new_apiproduct_name)
      subject.apiproducts[@new_apiproduct_name].should == 'approved'
    end    

    it 'revokes product' do 
      subject.add_product(@new_apiproduct_name)
      subject.revoke_product(@new_apiproduct_name)
      subject.apiproducts[@new_apiproduct_name].should == 'revoked'
    end    

    it 'removes product' do 
      subject.add_product(@new_apiproduct_name)
      subject.remove_product(@new_apiproduct_name)
      subject.apiproducts[@new_apiproduct_name].should_not be_present
    end    

  end

end




