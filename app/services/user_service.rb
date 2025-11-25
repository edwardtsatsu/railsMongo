class UserService
  DEFAULT_LIMIT = 50
  MAX_LIMIT = 100

  # ---------- RANGE-BASED (CURSOR) PAGINATION ----------
  def self.fetch_all(cursor: nil, limit: nil)
    limit = (limit || DEFAULT_LIMIT).to_i.clamp(1, MAX_LIMIT)

    scope = User.only(:_id, :name, :age, :email, :location)
                .order_by(_id: :asc)

    if cursor.present?
      begin
        bson_cursor = BSON::ObjectId.from_string(cursor)
        scope = scope.where(:_id.gt => bson_cursor)
      rescue BSON::ObjectId::InvalidId
        return Oj.dump({ error: "Invalid cursor value" })
      end
    end

    users = scope.limit(limit).to_a
    serialized = UserSerializer.serialize_collection(users)
    next_cursor = users.last&.id&.to_s

    Oj.dump(
      data: serialized,
      pagination: {
        limit: limit,
        next_cursor: next_cursor,
        has_more: next_cursor.present?
      }
    )
  end

  # ---------- FETCH SINGLE USER ----------
  def self.fetch(id)
    user = User.find(id)
    Oj.dump(UserSerializer.serialize(user))
  rescue Mongoid::Errors::DocumentNotFound
    Oj.dump({ error: "User not found" })
  end

  # ---------- CREATE USER ----------
  def self.create(params)
    user = User.new(params)
    if user.save
      Oj.dump(UserSerializer.serialize(user))
    else
      Oj.dump(errors: user.errors.full_messages)
    end
  end

  # ---------- UPDATE USER ----------
  def self.update(user, params)
    if user.update(params)
      Oj.dump(UserSerializer.serialize(user))
    else
      Oj.dump(errors: user.errors.full_messages)
    end
  end

  # ---------- DELETE USER ----------
  def self.destroy(user)
    user.destroy!
    Oj.dump({ success: true })
  end
end
