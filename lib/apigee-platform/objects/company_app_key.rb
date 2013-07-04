module ApigeePlatform::Objects
  class CompanyAppKey < Key
    set_prefix_options :company_name => :companyName, :app_name => :name
    self.site = self.site.to_s + "/companies/:company_name/apps/:app_name"
    set_primary_key :consumerKey
  end
end