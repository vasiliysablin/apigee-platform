module ApigeePlatform::Objects
  class Api < Base
    
    schema do
      string 'name'
      string 'description'
    end

    set_primary_key :name
  end
end