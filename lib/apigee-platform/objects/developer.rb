module ApigeePlatform::Objects
  class Developer < Base

    schema do
      string 'name', 'email', 'firstName', 'lastName', 'userName', 'organizationName', 'status'
    end

    set_primary_key :developerId

    validates_presence_of :firstName, :lastName, :userName, :email
    validates_format_of :email, :with => /\A(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\Z/i

    has_many :apps
    
    def id
      developerId || email
    end

  end
end