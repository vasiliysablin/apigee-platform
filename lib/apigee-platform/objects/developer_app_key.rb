module ApigeePlatform::Objects
  class DeveloperAppKey < Key
    set_prefix_options :developer_id => :developerId, :app_name => :name
    self.site = self.site.to_s + "/developers/:developer_id/apps/:app_name"
    set_primary_key :consumerKey
  end
end