#Import the necessary methods from tweepy library
from tweepy.streaming import StreamListener
from tweepy import OAuthHandler
from tweepy import Stream

import time
import os

import json

# https://dev.twitter.com/overview/api/tweets

#Variables that contains the user credentials to access Twitter API 
access_token = "131068458-EarC2m34rbcEoiWLqGYooK3Bqh3l0MXQpXqYwLgP"
access_token_secret = "S8OIJwqAjE4PQeS0UQTwha3zNqPbXz5uGtfbWJeAD73uI"
consumer_key = "ynB27DomMB8kemAAsmyGYlgKF"
consumer_secret = "5RkiaMFMgxS2ZYBPMFHj3ywrtwKSEcIQMGq7E2jpQLpIartmbq"

delim = ";"
# local_path = "C:\\Users\\Danil\\Documents\\150615_final software\\files\\"
workingDirectory = os.path.dirname(os.path.abspath(__file__)) + "\\"
local_file = workingDirectory + "qsdata.txt"

def parseData(data):
    tweet = json.loads(data)

    # print tweet

    try:
        tweetText = tweet["text"]
    except KeyError:
        tweetText = ""
        return None

    print tweet

    cat = tweetText.split()[0]

    if cat == '0' or cat == '1':

        # print tweet
    
        t = tweet["quoted_status"]["created_at"].replace(delim,',')
        t2 = time.mktime(time.strptime(t, '%a %b %d %H:%M:%S +0000 %Y'))
        user = "@" + tweet["quoted_status"]["user"]["screen_name"].replace(delim,',')

        textRaw = tweet["quoted_status"]["text"].replace(delim,',')

        word_list = textRaw.split()

        #replace
        remove_list = ['@QSActivate','#autodeskrobot']

        scrubbed_list = []

        for word in word_list:
            if word not in remove_list and 'http' not in word:
                scrubbed_list.append(word)

        text = ' '.join(scrubbed_list)

        msg = delim.join([cat, str(t2), t, user, text])

        print "STORED: " + msg.encode('utf-8')
    
        with open(local_file, 'a') as f:
            f.write(msg.encode('utf-8') + "\n")

#This is a basic listener that just prints received tweets to stdout.
class StdOutListener(StreamListener):

    def on_data(self, data):
        parseData(data)
        return True

    def on_error(self, status):
        print status


if __name__ == '__main__':

    #This handles Twitter authetification and the connection to Twitter Streaming API
    l = StdOutListener()
    auth = OAuthHandler(consumer_key, consumer_secret)
    auth.set_access_token(access_token, access_token_secret)
    stream = Stream(auth, l)
    stream.userstream()