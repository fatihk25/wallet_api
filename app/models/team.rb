class Team < Entity
  has_many :sessions, as: :entity, dependent: :destroy
end
