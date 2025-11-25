class UserSerializer
  def initialize(user)
    @user = user
  end

  # Serialize single user
  def serialize
    Oj.dump(as_hash)
  end

  # Serialize collection of users
  def self.serialize_collection(users)
    users.map { |u| new(u).as_hash }
  end

  # Hash representation
  def as_hash
    {
      id: @user.id.to_s,
      name: @user.name,
      age: @user.age,
      email: @user.email,
      location: @user.location
    }
  end
end
