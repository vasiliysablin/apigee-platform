module ApigeePlatform::Objects
  class DeveloperApp < App    
    set_primary_key :name
    set_prefix_options :developer_id => :developerId

    self.site = self.site.to_s + "/developers/:developer_id"

    validates_presence_of :name
    belongs_to :developer
    has_many :keys, :through => :credentials

    def self.element_name
      'app'
    end

  end
end