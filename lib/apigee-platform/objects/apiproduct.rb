module ApigeePlatform::Objects
  class Apiproduct < Base
    schema do
      string 'name'
    end

    set_primary_key :name

  end
end