import snscrape.modules.twitter as sntwitter
import pandas as pd
import time

t1 = time.time()
# Creating list to append tweet data to
tweets_list1 = []

# Using TwitterSearchScraper to scrape data and append tweets to list
for i,tweet in enumerate(sntwitter.TwitterSearchScraper('from:VonRufus23').get_items()):
    if i>100:
        break
    tweets_list1.append([tweet.date, tweet.id, tweet.rawContent, tweet.user.username])
    
# Creating a dataframe from the tweets list above 
tweets_df1 = pd.DataFrame(tweets_list1, columns=['Datetime', 'Tweet Id', 'Text', 'Username'])

t2 = time.time()
profiled_time = t2 - t1
print(profiled_time)
print(tweets_df1)