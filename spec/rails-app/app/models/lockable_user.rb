# User for testing out the account locking on failure.
#
class LockableUser < User
  devise :duo_authenticatable, :duo_lockable, :database_authenticatable,
         :registerable, :recoverable, :rememberable, :trackable, :validatable,
         :lockable
end
