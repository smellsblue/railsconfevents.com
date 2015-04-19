require "test_helper"

class UserTest < ActiveSupport::TestCase
  def test_admin_user_admin_status
    assert users(:farnsworth).admin?, "Farnsworth is an admin"
    assert users(:farnsworth).really_admin?, "Farnsworth is really an admin"
    assert_not users(:farnsworth).incognito_admin?, "Farnsworth is not in incognito mode"
  end

  def test_incognito_admin_user_admin_status
    assert_not users(:hermes).admin?, "Hermes is an admin but is incognito"
    assert users(:hermes).really_admin?, "Hermes is really an admin"
    assert users(:hermes).incognito_admin?, "Hermes is in incognito mode"
  end

  def test_normal_user_admin_status
    assert_not users(:fry).admin?, "Fry is not an admin"
    assert_not users(:fry).really_admin?, "Fry is not really an admin"
    assert_not users(:fry).incognito_admin?, "Fry is not in incognito mode"
  end

  def test_anonymous_admin_status
    assert_not Anonymous.user.admin?, "An anonymous user is not an admin"
    assert_not Anonymous.user.really_admin?, "An anonymous user is not really an admin"
    assert_not Anonymous.user.incognito_admin?, "An anonymous user is not in incognito mode"
  end

  def test_user_display_name_when_user_empty
    user = User.new name: "", username: "johndoe"
    assert_equal "johndoe", user.display_name
  end

  def test_user_display_name_when_user_and_username_empty
    user = User.new name: "", username: ""
    assert_equal "Someone", user.display_name
  end

  def test_user_can_update_username
    user = users :fry
    user.update_me! update_me_params(user, name: "Captain Yesterday")
    user.reload
    assert_equal "Captain Yesterday", user.name
  end

  def test_user_can_remove_email
    user = users :fry
    user.update_me! update_me_params(user, email: "")
    user.reload
    assert user.email.blank?, "User's email address should have been removed"
  end

  def test_anonymous_cannot_edit_themselves
    assert_raises PermissionError do
      Anonymous.user.update_me! update_me_params(users(:fry), {})
    end
  end

  def test_admin_user_can_go_incognito
    user = users :farnsworth
    user.update_me! update_me_params(user, incognito: "true")
    user.reload
    assert user.incognito_admin?, "User turned on incognito mode"
    assert_not user.admin?, "User should not be recognized as admin"
  end

  def test_normal_user_cannot_go_incognito
    user = users :fry
    user.update_me! update_me_params(user, incognito: "true")
    user.reload
    assert_not user.incognito_admin?, "Normal user cannot go incognito"
  end

  def test_incognito_user_can_remove_incognito
    user = users :hermes
    user.update_me! update_me_params(user, incognito: nil)
    user.reload
    assert_not user.incognito_admin?, "User turned off incognito mode"
    assert user.admin?, "User should be recognized as admin again"
  end

  private

  def update_me_params(user, new_params)
    existing_params = {
      name: user.name,
      email: user.email
    }

    if user.incognito_admin?
      existing_params[:incognito] = "true"
    end

    existing_params.merge(new_params)
  end
end
