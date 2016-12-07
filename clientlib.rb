require 'uri'
require 'net/http'
require 'json'
require "byebug"
require 'cgi'


def http_request(request_type, url, token, params)
	uri = URI.parse(url)
	http = Net::HTTP.new(uri.host, uri.port)

	if request_type=="Post"
		request = Net::HTTP::Post.new(uri.request_uri)
	elsif request_type=="Get"
		request = Net::HTTP::Get.new(uri.request_uri)
	elsif request_type=="Put"
		request = Net::HTTP::Put.new(uri.request_uri)
	elsif request_type=="Patch"
		request = Net::HTTP::Patch.new(uri.request_uri)
	elsif request_type=="Delete"
		request = Net::HTTP::Delete.new(uri.request_uri)
	end

	if token!=nil then
		cookie = CGI::Cookie.new("access_token", token)
		request['Cookie'] = cookie.to_s
	end

	if params!=nil
		response = http.request(request, params)
	else
		response = http.request(request)
	end
	return response
end

class NanoTwitter
	attr_accessor :token, :host, :user_id
 	def init host
 		self.host = host
 		return 1
 	end
	def login(username,password)

		params  = {'username' => username, 'password' => password}.to_json
		response = http_request "Post", self.host+"/api/v1/users/login", nil, params
		if response.code == "200" then
			response_message = JSON.parse response.body
			if response_message["resultMsg"] == "Password is not correct." then
				puts "Wrong password. Try again."
				return 0
			elsif response_message["resultMsg"] == "User not found." then
				puts "User does not exist"
			else
				self.token = response_message["resultMsg"]["access_token"]
				response = http_request "Put", self.host+"/api/v1/users/selfid", self.token, nil
				response_message = JSON.parse response.body
				self.user_id = response_message["resultMsg"]["user"]
			return 1
			end
		else
			puts "Login error" 
			return 0
		end
	end

	def logout
		if self.token != nil then
			self.token = nil
			self.user_id = nil
			puts "Bye"
			return 1
		else
			puts "You are not logged in to NanoTwitter"
			return 0
		end
	end

	def my_followers
		if self.token == nil then
			puts "Please, login first in order to see your followers"
			return 0
		else
			response = http_request "Get", self.host+"/api/v1/users/"+self.user_id.to_s+"/followers", self.token, nil
			if response.code == "200" then
				response_message = JSON.parse response.body
				followers = response_message["resultMsg"]["followers"]
				return followers  #returns an array of hashes, each with user info
			else
				return 0
			end
		end
	end

	def my_followings
		if self.token == nil then
			puts "Please, login first in order to see your followers"
			return 0
		else
			response = http_request "Get", self.host+"/api/v1/users/"+self.user_id.to_s+"/followings", self.token, nil
			if response.code == "200" then
				response_message = JSON.parse response.body
				followings = response_message["resultMsg"]["followings"]
				return followings  #returns an array of hashes, each with user info
			else 
				return 0
			end
		end
	end

	def my_timeline no_of_tweets
		if self.token == nil then
			puts "Please, login first in order to see your timeline"
			return 0
		else
			response = http_request "Get", self.host+"/api/v1/homeline?id_max=0&number="+no_of_tweets.to_s, self.token, nil
			if response.code == "200" then
				response_message = JSON.parse response.body
				timeline = response_message["resultMsg"]["home_line"]
				return timeline  #returns an array of hashes, each with user info
			else
				return 0
			end
		end
	end

	def post_tweet content 
		if self.token == nil then
			puts "Please, login first in order to post a new tweet"
			return 0
		else
			params  = {'content' => content, 'reply_to_tweet_id' => nil}.to_json
			response = http_request "Post", self.host+"/api/v1/tweets", self.token, params
			if response.code == "200"
				return 1
			else return 0
			end
		end
	end

	def follow_user following_id 
		if self.token == nil then
			puts "Please, login first in order to follow another user"
			return 0
		else
			params  = {'following_id' => following_id}.to_json
			response = http_request "Post", self.host+'/api/v1/follows', self.token, params
			if response.code == "200"
				return 1
			else return 0
			end
		end
	end
end
