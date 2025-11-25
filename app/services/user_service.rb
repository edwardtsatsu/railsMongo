# frozen_string_literal: true

class UserService
  DEFAULT_LIMIT = 10
  MAX_LIMIT     = 10

  FIELDS = %i[_id name age email location].freeze

  class << self
    def fetch_all(cursor: nil, limit: nil)
      limit = (limit || DEFAULT_LIMIT).to_i.clamp(1, MAX_LIMIT)

      scope = User.only(*FIELDS).order_by(_id: :asc)

      if cursor
        bson_cursor = safe_cursor(cursor)
        return { error: "Invalid cursor value" } unless bson_cursor

        scope = scope.where(:_id.gt => bson_cursor)
      end

      users = scope.limit(limit).to_a

      {
        data: UserSerializer.serialize_collection(users),
        pagination: pagination_obj(users, limit)
      }
    end

    def fetch(id)
      user = User.only(*FIELDS).find(id)
      UserSerializer.serialize(user)
    rescue Mongoid::Errors::DocumentNotFound
      { error: "User not found" }
    end

    def create(params)
      user = User.new(params)
      user.save ? UserSerializer.serialize(user) : { errors: user.errors.full_messages }
    end

    def update(user, params)
      user.update(params) ? UserSerializer.serialize(user) : { errors: user.errors.full_messages }
    end

    def destroy(user)
      user.destroy!
      { success: true }
    end

    private

    def safe_cursor(cursor)
      BSON::ObjectId.from_string(cursor)
    rescue BSON::ObjectId::InvalidId, BSON::ObjectId::Invalid
      nil
    end

    def pagination_obj(users, limit)
      last = users.last
      {
        limit: limit,
        next_cursor: last ? last.id.to_s : nil,
        has_more: !!last
      }
    end
  end
end
