## Text mining Reddit
![Alt text](https://github.com/ApurvaNaik/textMiningReddit/raw/686298c6717d01bfa2c0d83814f211bbbce47982/wc3.png)

### About reddit
Here is the definition of the website from Wikipedia:

```
Reddit is a social news and entertainment website where registered users submit content in the form of links or text posts. Users then vote each submission "up" or "down" to rank the post and determine its position on the site's pages. Content entries are organized by areas of interest called "subredtdits".
```
 According to their statistics [here](https://www.reddit.com/about), Reddit receives over 7 billion page views from 227 million unique visitors a month. Further, these users vote 22 million times each day. This makes it a great platform for social analysis. Also, they have a crawl-friendly API that allows easy access for parsing comments and a lots of other things.

 In order to narrow it down to one subreddit, I went over to [redditmetrics.com](http://redditmetrics.com/top) to make my selection. I chose r/technology with more that 5 million subscribers.

I am interested in knowing what the hivemind at r/technology talks about, what brings these people together in online communities and what keeps those communities together. It would be interesting to see what tickles this fickle monster.

### Problem and Dataset
##### Overview
1. Find interesting and defining characteristics of the community.
2. Identify the attitude of the community towards the things it talks about the most.
3. Identify the general mood of the discussion.

I have used a variety of techniques to achieve this:
1. Word Frequency Analysis: Counting how many times a particular word occurs
2. Sentiment Analysis: Identifying the opinion of the community towards certain things.

##### Scraping data
I had initially planned to use [Scrapy](http://doc.scrapy.org/en/latest/) to parse comments from reddit because I was learning to code in Python and building my own script would be good coding practice. However, I realized it was going to be very tricky to grab both top posts from the past year and the top 10 comments from each top post. I ultimately ended up using [Praw](http://praw.readthedocs.io/en/stable/), a reddit API wrapper in Python.

*I parsed close to 10,000 posts and comments from r/technology.*

I then cleaned punctuation, lowercased words and removed stop-words, which resulted in a dataset of words that is now ready to be analyzed.

### Text Analysis
I explored the data by:
1. Finding the most commonly occurring words.
2. Filtering data by most talked about entities (people, companies, technology).

##### Word frequency plots
The wordcloud shown at the head of this page is plotted from the entire corpus of posts and comments parsed from r/technology. The "name entities"  are apparent once we look past the high frequency generic words. I'd like to grab a few of these name entities and learn their characteristics.

*The 8 most spoken about entities are*:
![Alt text](https://github.com/ApurvaNaik/textMiningReddit/raw/master/ewf.png)

I'd also like to determine whether any of these correlated with upvotes.
![Alt text](https://github.com/ApurvaNaik/textMiningReddit/raw/master/tUpvotes.png)

It is interesting to note that although people have mentioned "internet" and "government" most frequently, those posts don't seem to have garnered many votes. On the other hand, posts or comments mentioning companies have more upvotes. This could be because they express an opinion about the company that others relate to.

*"give eg."*

Next is to see how the upvotes are distributed. The bar graph shows the percentage of upvotes proportional to the total number of posts containing the keywords given on the x-axis.

![Alt text](https://github.com/ApurvaNaik/textMiningReddit/raw/master/prop.png)

Both number of posts and number of upvotes have been normalized to the range(0,1) for easy comparison. **google** has nearly equal proportion of posts and upvotes. __reddit__ has the least number of posts and __government__ has the least upvotes. This confirms my earlier suspicion that people donn't upvote texts containing generic words. It can be seen from the yellow histogram that __reddit__ is the second least frequent word, yet text containing it is the 4th highest upvoted.

### Quick and dirty sentiment analysis
Now that I know what the technology community at Reddit is talking about, I'm interested in seeing what sentiment they harbor towards it. There are a number of ways of doing this, varying in complexity. This time, I've used the bag-of-words model.

```
In the bag-of-words feature, the text to be analyzed is literally shred into individual words (called tokens) and collected in a "bag of words". The Naive Bayes Classifier then compares words in this bag to those in two other bags labeled "Positive" and "Negative". The words in our bag are then labeled positive or negative, thus implying the sentiment.
```
The {tm.sentiment.plugin} package in R is well suited for this purpose. In addition to sentiment score it also outputs __polarity__ (is the sentiment associated positive or negative?) and __subjectivity__ (how much sentiment does the entity garner?) scores.

I have chosen to analyze text containing the keywords "google", "apple" and "encryption". Both companies have maximum upvotes, although Apple has been mentioned far less in proportion to the upvotes it has received. Encryption on the other hand has proportionally equal mentions and upvotes.

*all 3 sentiment scores in one line*

Is reddit full of skeptics? At least the results of my analysis say so. One one hand its possible that the negative sentiment is directed not necessarily towards the entity, but towards another:
```
"about a month ago i spent an hour or so getting all the extra garbage toolbars and crap avg installed off my system ... avg installed a boatload of crapware. it kept reinstalling itself. google rescued me"
```
Here, the negative sentiment is about avg, not google. Yet this has been classified as a negative sentiment with a score of -0.02. It is one of the drawbacks of using a Bayes classifier.

*__Note:__ This can be resolved to some extent by collecting more data to even out the bias and by analysing not just words but combination of 2 or 3 words. It would also be interesting to demonstrate juxtaposition analysis: finding which entities co-occur with, say google or apple.*

##### More wordclouds

*Google*
![Alt text](https://github.com/ApurvaNaik/textMiningReddit/raw/master/googleWC.png)

*Apple*
![Alt text](https://github.com/ApurvaNaik/textMiningReddit/raw/master/appleWC.png)

*encryption*
![Alt text](https://github.com/ApurvaNaik/textMiningReddit/raw/master/encryptionWC.png)


#### Time analysis
I was interested to know if r/technology has been talking about anything different in the past month.

*Comparison of wordcloud for comments over the past year and past month*
