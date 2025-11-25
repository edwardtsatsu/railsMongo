# frozen_string_literal: true

class UserSerializer
  class << self
    def serialize(user)
      {
        id: user.id.to_s,
        name: user.name,
        age: user.age,
        email: user.email,
        location: user.location
      }
    end

    def serialize_collection(users)
      Array.new(users.length) do |i|
        u = users[i]

        {
          id: u.id.to_s,
          name: u.name,
          age: u.age,
          email: u.email,
          location: u.location
        }
      end
    end
  end
end
