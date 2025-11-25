class UserService
  # Fetch all users (returns serialized JSON)
  def self.fetch_all
    users = User.only(:_id, :name, :age, :email, :location)
    Oj.dump(UserSerializer.serialize_collection(users))
  end

  # Fetch single user (serialized)
  def self.fetch(id)
    user = User.find(id)
    Oj.dump(UserSerializer.serialize(user))
  rescue Mongoid::Errors::DocumentNotFound
    Oj.dump({ error: "User not found" })
  end

  # Create user (serialized)
  def self.create(params)
    user = User.new(params)
    if user.save
      Oj.dump(UserSerializer.serialize(user))
    else
      Oj.dump({ errors: user.errors.full_messages })
    end
  end

  # Update user (serialized)
  def self.update(user, params)
    if user.update(params)
      serialize(user)
    else
      Oj.dump({ errors: user.errors.full_messages })
    end
  end

  # Delete user
  def self.destroy(user)
    user.destroy!
    Oj.dump({ success: true })
  end

  # ----------------------------
  # Serialization
  # ----------------------------
  def self.serialize(user)
    Oj.dump(
      id: user.id,
      name: user.name,
      age: user.age,
      email: user.email,
      location: user.location
    )
  end

  def self.serialize_collection(users)
    Oj.dump(users.map do |u|
      {
        id: u.id,
        name: u.name,
        age: u.age,
        email: u.email,
        location: u.location
      }
    end)
  end
end
