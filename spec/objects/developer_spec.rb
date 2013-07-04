require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe 'Developer' do 
  before :all do 
    @developer = {
      :email        =>"mytestdeveloper@example.com",
      :firstName    =>"mytest",
      :lastName     =>"mytest",
      :userName     =>"mytest",
      :apps         => ['appp1', 'app2'],
      :developerId      => 'ASDFGHJ1234567',
      :organizationName => 'some organization',
      :status       => 'active',
      :attributes   => [],
      :createdAt    => 1372060415592,
      :createdBy    => "createdby@example.com",
      :lastModifiedAt   => 1372060415592,
      :lastModifiedBy   => "modifiedby@example.com"
    }

    ActiveResource::HttpMock.respond_to do |mock|
      org = ApigeePlatform::Objects::Base.config[:organization]
      mock.get "/v1/o/#{org}/developers", GET_HEADERS, [@developer[:email]].to_json
      mock.get "/v1/o/#{org}/developers/#{@developer[:email]}", GET_HEADERS, @developer.to_json
      mock.get "/v1/o/#{org}/developers/#{@developer[:developerId]}/apps", GET_HEADERS, @developer[:apps].to_json
      mock.put "/v1/o/#{org}/developers/#{@developer[:developerId]}", POST_HEADERS, @developer.to_json
      mock.post "/v1/o/#{org}/developers", POST_HEADERS, @developer.to_json
    end
  end

  describe 'class' do 
    subject { ApigeePlatform::Objects::Developer }

    it "won't create empty object" do 
      subject.new.save.should be_false
    end


    it "assign attributes after create" do 
      dev = subject.create @developer.reject{|k,v| k.in?(:developerId, :apps) }
      dev.id.should == @developer[:developerId]
    end


    it "returns collection" do 
      subject.all.should include(@developer[:email])
    end

    it "could find element" do 
      subject.find(@developer[:email]).id.should == @developer[:developerId]
    end
  end

  describe 'object' do 
    subject { ApigeePlatform::Objects::Developer.find(@developer[:email])  }
    
    it "could be updated" do 
      subject.firstName += '1'
      subject.save.should be_true
    end 

    it "has many apps" do 
      subject.apps.to_set.should == @developer[:apps].to_set
    end

    it "returns app from nested collection" do 
      subject.app.should be_kind_of ApigeePlatform::Objects::DeveloperApp
    end

  end
end
