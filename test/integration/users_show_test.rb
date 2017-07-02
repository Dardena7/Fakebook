require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:alex)
		@other_user = users(:archer)
		@not_activated_user = users(:notactive)
	end

	test "Redirect on show non existant user id" do
		get "http://localhost:3000/users/0"
		assert_redirected_to root_url
	end
	
	test "Can reach profile of activated user, logged in or not" do
		get user_path(@other_user)
		assert_template 'users/show'
		get root_path
		log_in_as(@user)
		get user_path(@other_user)
		assert_template 'users/show'
	end

	test "Cannot reach profile of non activated user, logged in or not" do
		get user_path(@not_activated_user)
		assert_redirected_to root_url
		log_in_as(@user)
		get user_path(@not_activated_user)
		assert_redirected_to root_url
	end

end
