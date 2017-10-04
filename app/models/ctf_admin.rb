class CtfAdmin < ApplicationRecord
  belongs_to :users
  belongs_to :capture_the_flag
end
