$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'simplecov'
SimpleCov.start
require 'apigee-platform'
require 'rspec'
require 'rspec/mocks'
require 'ostruct'

test_user = 'test@example.com'
test_pwd  = 'password'
org       = 'organization'
auth_key = Base64::encode64("#{test_user}:#{test_pwd}").chomp
GET_HEADERS = {"Authorization"=>"Basic #{auth_key}", "Accept"=>"application/json"}
POST_HEADERS = {"Authorization"=>"Basic #{auth_key}", "Content-Type"=>"application/json"}
NO_CONTENT_HEADERS = {"Authorization"=>"Basic #{auth_key}", "Content-Type"=>"application/octet-stream"}
ApigeePlatform::Objects::Base.configure :user => test_user, :password => test_pwd, :organization => org