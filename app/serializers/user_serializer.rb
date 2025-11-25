class UserSerializer
  def initialize(user)
    @user = user
  end

  def as_hash
    {
      id: @user.id,
      name: @user.name,
      age: @user.age,
      email: @user.email,
      location: @user.location
    }
  end

  # Fast batch serialization
  def self.serialize_collection(users)
    users.map { |u| new(u).as_hash }
  end
end
