require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should not save user without email' do
    user = User.new(email: '', password: 'password')
    assert_not user.save
  end

  test 'should not save user with password less 8' do
    user = User.new(email: 'you@example.com', password: 'smth')
    assert_not user.save
  end
end
