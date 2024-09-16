class User < Entity
  has_many :sessions, as: :entity, dependent: :destroy
end
