module MongoidModels

	class User
    include Mongoid::Document
    store_in :users
    has_many :documents, :class_name => "MongoidModels::Document", :dependent => :destroy


    field :login, type: String
    field :password, type: String

    validates_presence_of :login, :password

    # will be performed if validations pass
    before_save { self.password = BCrypt::Password.create(self.password) }
      
    class << self
      def authenticate(login, password)
        raise ArgumentError if login.blank? || password.blank?
        user = User.where(login: login).first
        if user && BCrypt::Password.new(user[:password]) == password
          return user
        end
      end
    end
	end
end

