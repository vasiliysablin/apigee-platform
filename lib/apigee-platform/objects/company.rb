module ApigeePlatform::Objects
  class Company < Base
    
    schema do
      string 'name', 'displayName', 'status'
    end

    set_primary_key :name
    validates_presence_of :name
    has_many :apps, :company_name => :name

  end
end