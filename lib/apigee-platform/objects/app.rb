module ApigeePlatform::Objects
  class App < Base

    schema do
      string 'name'
    end

    set_primary_key :appId

  end
end