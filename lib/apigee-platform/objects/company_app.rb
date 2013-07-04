module ApigeePlatform::Objects
  class CompanyApp < App    
    set_primary_key :name
    set_prefix_options :company_name => :companyName

    self.site = self.site.to_s + "/companies/:company_name"
    validates_presence_of :name

    belongs_to :company, :key => :companyName
    has_many :keys, :through => :credentials
    
    def self.element_name
      'app'
    end

  end
end