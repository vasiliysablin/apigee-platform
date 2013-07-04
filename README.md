# ApigeePlatform

ApigeePlatform is a ruby wrapper for Apigee Platform API (http://apigee.com/).

Full API documentation - http://apigee.com/docs/api/api-resources

Gem is based on ActiveResource.

## Installation
    gem install apigee-platform

## Usage
    
### Initialization
    require 'apigee-platform'
    
    ApigeePlatform::Objects::Base.configure :user => 'user@example.com', :password => 'your_password', :organization => 'your_apigee_org'

### Examples
  
#### Developer

  Retreive developers list

    ApigeePlatform::Objects::Developer.all
    # => ["liukang@example.com", "kano@example.com"]

  Find developer. You could use email or ID here.

    developer = ApigeePlatform::Objects::Developer.find 'johnny@example.com'

  Create new developer

    developer = ApigeePlatform::Objects::Developer.new :firstName => 'Johnny', :lastName => 'Cage', :userName => 'johnnycage', :email => 'johnny@example.com'
    developer.save
    # => true

    developer.errors.full_messages
    # => [] 

  Update developer attributes

    developer.firstName = 'SuperJohnny'
    developer.save
    # => true 

  Get Apps assigned to developer

    developer.apps
    # => ['app1', 'app2']

  Create new app for developer

    new_app = developer.app
    new_app.name = 'my_super_app'
    new_app.save
    # => true

  Find developer app by name

    app = developer.app 'my_super_app'

    # or you could use DeveloperApp object

    app = ApigeePlatform::Objects::DeveloperApp.find 'my_super_app', :params => {:developer_id => DEVELOPER_ID_OR_EMAIL}

  Get developer app keys. Keys were created automatically by Apigee with app.
    
    app.keys

  Manage apiproducts of key

    key = app.keys.first

    # assigned apiproducts for key
    key.apiproducts
    # => {}

    # existing apiproducts list
    ApigeePlatform::Objects::Apiproduct.all
    # => ['mkworld', 'midway']

    key.add_product 'mytest'
    # => 'pending'

    key.apiproducts
    # => {"mytest"=>"pending"} 

    # approve product
    key.approve_product 'mytest'
    # => "approved" 

    # revoke product
    key.revoke_product 'mytest'
    # => "revoked" 

    # remove product 
    key.remove_product 'mytest'
    # => true

  Delete developer app

    app.destroy

  Delete developer

    developer.destroy


#### Company

  Comapnies API is similar to developers API.

    company = ApigeePlatform::Objects::Company.create :name => 'my_new_company'
    
    company.apps
    # => []

    new_app = company.app
    new_app.name = 'my_super_app2'
    new_app.save
    # => true

    key = new_app.keys.first
    
    key.add_product 'mytest'
    # => 'pending'

    key.apiproducts
    # => {"mytest"=>"pending"} 

    # approve product
    key.approve_product 'mytest'
    # => "approved" 

    # revoke product
    key.revoke_product 'mytest'
    # => "revoked" 

    # remove product 
    key.remove_product 'mytest'
    # => true

#### Custom attributes
    
  Some resources (developer, company, apiproduct) has custom attributes. It is accessible under custom_attributes method which behave like a Hash.

    developer.custom_attributes
    # => {}

    developer.custom_attributes[:attr1] = 'val1'
    developer.save

## Contributing to apigee-platform
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.

## Copyright

Copyright (c) 2013 Vasiliy Sablin. See LICENSE.txt for
further details.









