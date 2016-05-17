## Text mining Reddit
*wordcloud from r/technology*

#### About reddit
First, a little explanation on what reddit is. Here is the definition of the website from Wikipedia:

```
Reddit is a social news and entertainment website where registered users submit content in the form of links or text posts. Users then vote each submission "up" or "down" to rank the post and determine its position on the site's pages. Content entries are organized by areas of interest called "subredtdits".
```
 According to their statistics [here](https://www.reddit.com/about), they receive over 7 billion page views from 227 million unique visitors a month. Further, these users vote 22 million times each day. This makes Reddit a great platform for social Analysis. Also, they have a spider-friendly API that allows easy access for parsing comments and a lots of other things.

 In order to narrow it down to one subreddit, I went over to [redditmetrics.com](http://redditmetrics.com/top) to make my selection. I chose r/technology with more that 5 million subscribers.
I am interested in knowing what the hivemind at r/technology talks about, what brings these people together in online communities and what keeps those communities together. It would be interesting to discover patterns that describe what tickles this fickle monster.

#### Problem and Dataset
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

#### Data Analysis

I explored the data by:
1. Finding the most commonly occurring words.
2. Filtering data by most talked about entities (unique words).

*general word frequency hist*

*specific word frequency hist*

My next task was to determine whether any of these metric correlated with upvotes. Below are a few graphs displaying these metrics on all the comments.

*specific entities v/s upvotes*

#### Sentiment Analysis
Next, I wanted to find out what kind of attitude the community harbored towards the entities I filtered in the previous analysis. I have used Naive Bayes classification to identify positive, neutral or negative attitude.

Below are a few graphs displaying popular opinion about:
(graph, wordcloud)
*Comcast*
*Google*
*Government*
*Apple*
*Encryption*

#### Time analysis
I was interested to know if r/technology has been talking about anything different in the past month.

Comparison of wordcloud for comments over the past year and past month
