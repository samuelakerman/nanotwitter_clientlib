require_relative 'clientlib'
require 'minitest/autorun'
require 'minitest/spec'
require 'webrat/core/matchers'
require "byebug"
require_relative Dir.pwd+'/clientlib.rb'

class TestClientLib < Minitest::Test

	def setup
		@client = NanoTwitter.new 
		@response_init = @client.init "http://nanotwitter-xx.herokuapp.com/"
		@response_login = @client.login("Dan","Lt1j3sGi7")
	end

	def test_init
		assert_equal(1,@response_init)	
	end

	def test_login
		assert_equal(1,@response_login)
	end

	def test_followers
		#Fetch my followers
		response_followers = @client.my_followers
		assert_operator response_followers.count, :>=,9
	end

	def test_followings
		#Fetch the users I am following
		response_followings = @client.my_followings
		assert_operator response_followings.count, :>=,2
	end

	def test_timeline
		response_timeline = @client.my_timeline 50
		assert_operator response_timeline.count, :>=,19
	end

	def test_post_tweet
		#Post tweet
		response_post = @client.post_tweet "This is a test tweet for NanoTwitter" 
		assert_equal(1,response_post)
	end

	def test_follow_user
		response_follow = @client.follow_user 8
		assert_equal(1,response_follow)
	end

	def test_logout
		response_logout = @client.logout
		assert_equal(1,response_logout)
	end
end
