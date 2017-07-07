require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
	
	def setup
		@relationship = Relationship.new(follower_id: users(:alex).id, followed_id: users(:archer).id)
	end

	test "should be valid" do
		assert @relationship.valid?
	end

	test "should require a follower id" do
		@relationship.follower_id = nil
		assert_not @relationship.valid?
	end

	test "should require a followed id" do
		@relationship.followed = nil
		assert_not @relationship.valid?
	end

end
