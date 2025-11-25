class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :age, type: Integer
  field :email, type: String
  field :location, type: String

  # DB-level validations
  validates :name, presence: true
  validates :age, presence: true, numericality: { greater_than: 0 }
  validates :email, presence: true, uniqueness: true

  # MongoDB Index for fast uniqueness check
  index({ email: 1 }, { unique: true, name: "email_index" })

  # chnage from _id to id
  def id
    _id.to_s
  end
end
