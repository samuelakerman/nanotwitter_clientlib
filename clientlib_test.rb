require_relative 'clientlib'

client = NanoTwitter.new 
#client.init "http://127.0.0.1:4567"

#Specify URL were web server is
client.init "http://nanotwitter-xx.herokuapp.com/"

#Login as user Dan
client_dan = client.login("Dan","096iL3856")

#Fetch my followers
client.my_followers

#Fetch the users I am following
client.my_followings

#Fetch my timeline
client.my_timeline 50

#Post tweet
client.post_tweet "This is a test tweet for NanoTwitter" 

#Logout
client.logout

#Error. Not logged in
client.logout
