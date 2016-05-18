## Text mining Reddit
![Alt text](https://github.com/ApurvaNaik/textMiningReddit/raw/686298c6717d01bfa2c0d83814f211bbbce47982/wc3.png)

### About reddit
First, a little explanation on what reddit is. Here is the definition of the website from Wikipedia:

```
Reddit is a social news and entertainment website where registered users submit content in the form of links or text posts. Users then vote each submission "up" or "down" to rank the post and determine its position on the site's pages. Content entries are organized by areas of interest called "subredtdits".
```
 According to their statistics [here](https://www.reddit.com/about), they receive over 7 billion page views from 227 million unique visitors a month. Further, these users vote 22 million times each day. This makes Reddit a great platform for social Analysis. Also, they have a spider-friendly API that allows easy access for parsing comments and a lots of other things.

 In order to narrow it down to one subreddit, I went over to [redditmetrics.com](http://redditmetrics.com/top) to make my selection. I chose r/technology with more that 5 million subscribers.
I am interested in knowing what the hivemind at r/technology talks about, what brings these people together in online communities and what keeps those communities together. It would be interesting to see what tickles this fickle monster.

### Problem and Dataset
##### Overview
1. Find interesting and defining characteristics of the community.
2. Identify the attitude of the community towards the things it talks about the most.
3. Identify the general mood of the discussion.

In order to achieve these goals, I have used a variety of techniques:
1. Word Frequency Analysis: Counting how many times a particular word occurs
2. Sentiment Analysis: Identifying the opinion of the community towards certain things.

##### Scraping data
I had initially planned to use [Scrapy](http://doc.scrapy.org/en/latest/) to parse comments from reddit because I was learning to code in Python and building my own script would be good coding practice. However, I realized it was going to be very tricky to grab both top posts from the past year and the top 10 comments from each top post. i ultimately ended up using [Praw](http://praw.readthedocs.io/en/stable/), a reddit API wrapper in Python.

By doing this I parsed close to 10,000 posts and comments from r/technology.

I then cleaned punctuation, lowercased words and removed stop-words, which resulted in a dataset of words that is now ready to be analyzed.

### Text Analysis

I explored the data by:
1. Finding the most commonly occurring words.
2. Filtering data by most talked about entities (unique words).

##### Word frequency plots
*general word frequency hist*
![Alt text](https://github.com/ApurvaNaik/textMiningReddit/raw/master/gwf.png)

*specific word frequency hist*

![Alt text](https://github.com/ApurvaNaik/textMiningReddit/raw/master/ewf.png)

My next task was to determine whether any of these metric correlated with upvotes. Below are a few graphs displaying these metrics on all the comments.

![Alt text](https://github.com/ApurvaNaik/textMiningReddit/raw/master/tUpvotes.png)

It is interesting to note that although people have mentioned "internet" and "government" most frequently, those posts don't seem to have garnered many votes. On the other hand, posts or comments mentioning companies have more upvotes. This could be because they express an opinion about the company that others relate to.

*"give eg."*

Next is to see how the upvotes are distributed. The bar graph shows the percentage of upvotes proportional to the total number of posts containing the keywords given on the x-axis.

![Alt text](https://github.com/ApurvaNaik/textMiningReddit/raw/master/prop.png)

Both number of posts and number of upvotes have been normalized to the range(0,1) for easy comparison. "google" has nearly equal proportion of posts and upvotes. "reddit" has the least number of posts and "government" has the least upvotes. This confirms my earlier suspicion that people donn't upvote texts containing generic words. It can be seen from the yellow histogram that "reddit" is the second least frequent word, yet text containing it is the 4th highest upvoted.

##### Wordclouds
I wanted to find out what kind of attitude the community harbored towards some of the entities I've investigated in the previous analysis. I have chosen to analyze text containing the keywords "google", "apple" and "encryption". Both companies have maximum upvotes, although Apple has been mentioned far less in proportion to the upvotes it has received. "encryption" on the other hand has proportionally equal mentions and upvotes.

Below are a few graphs displaying popular opinion about:
(graph, wordcloud)

*Google*
![Alt text](https://github.com/ApurvaNaik/textMiningReddit/raw/master/googleWC.png)

*Apple*
![Alt text](https://github.com/ApurvaNaik/textMiningReddit/raw/master/appleWC.png)

*encryption*
![Alt text](https://github.com/ApurvaNaik/textMiningReddit/raw/master/encryptionWC.png)

### Sentiment Analysis


I have used Naive Bayes classification to identify positive, neutral or negative attitude.
(*NLP lecture*)
#### Time analysis
I was interested to know if r/technology has been talking about anything different in the past month.

*Comparison of wordcloud for comments over the past year and past month*
