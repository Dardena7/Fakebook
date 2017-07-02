require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

	def setup
		ActionMailer::Base.deliveries.clear
	end

	test "get signup_path" do
		get signup_path
		assert_response :success 
	end
	
	test "invalid signup information" do
		get signup_path
		assert_select "form[action=?]", "/signup"
		assert_no_difference "User.count" do
			post users_path, params: { user: { name: "",
																				 email: "user@invalid",
																				 password: "foo",
																				 password_confirmation: "bar"
																 } 
											 }
		end
		assert_template 'users/new'
		assert_select "form[action=?]", "/signup"
		assert_select 'div#error_explanation'
		assert_select 'div.field_with_errors'
	end
	
	test "valid signup information with account activation" do
		get signup_path
		assert_difference "User.count", 1 do
			post users_path, params: { user: { name: "example",
																				 email: "emailexample8z7d5z@validemail.com",
																				 password: "Hello1234",
																				 password_confirmation: "Hello1234"
																}
											}
		end
		assert_equal 1, ActionMailer::Base.deliveries.size
		user = assigns(:user)
		assert_not user.activated?
		log_in_as(user)
		assert_not is_logged_in?
		get edit_account_activation_path("invalid token", email: user.email)
		assert_not is_logged_in?
		get edit_account_activation_path(user.activation_token, email: user.email)
		assert user.reload.activated?
		follow_redirect!
		assert_template 'users/show'
		assert_not flash.empty?
		assert is_logged_in?
	end

end
