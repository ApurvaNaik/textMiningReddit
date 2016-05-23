## Text mining Reddit
![Alt text](https://github.com/ApurvaNaik/textMiningReddit/raw/master/img/wc2.png)

### About Reddit
Wikipedia defines Reddit as
```
 a social news and entertainment website where registered users submit content in the form of links or text posts. Users then vote each submission "up" or "down" to rank the post and determine its position on the site's pages. Content entries are organized by areas of interest called "subreddits".
```
 According to their statistics [here](https://www.reddit.com/about), Reddit receives over 7 billion page views from 227 million unique visitors a month. Further, these users vote 22 million times each day. This makes Reddit a great platform for social analysis.

 In order to narrow it down to one subreddit, I went over to [redditmetrics.com](http://redditmetrics.com/top) to make my selection. I chose r/technology with more that 5 million subscribers. There is a nice summary posted on their [home page](https://www.reddit.com/r/technology/) about what r/technology is about.
 ```
 r/technology is a place to share and discuss the latest developments, happenings and curiosities in the world of technology; a broad spectrum of conversation as to the innovations, aspirations, applications and machinations that define our age and shape our future.
```

 I am interested in knowing what the hivemind at r/technology discusses, what it loves, and hates. I want to know tickles this fickle monster.

### Problem and Dataset
I started by looking for some interesting and defining characteristics of this community.  Through word frequency analysis, I found what r/technology talks about the most. I did sentiment analysis to identify the attitude of this community towards some of the most discussed brands and ideas. I have drawn inspiration from [Jeff Breen](https://jeffreybreen.wordpress.com/2011/07/04/twitter-text-mining-r-slides/) while doing sentiment analysis.

##### Scraping and preparing data
I had initially planned to use [Scrapy](http://doc.scrapy.org/en/latest/) to parse comments from reddit. However, I realized it was going to be very tricky to grab both top posts and top 10 comments from each top post. I ultimately ended up using [Praw](http://praw.readthedocs.io/en/stable/)(Python Reddit API Wrapper), a package specifically written to access Reddit's API.

*I parsed close to 10,000 most posts and comments from the past year from r/technology.*

I then cleaned punctuation, digits and whitespace, lowercased words, and removed stop-words, resulting in a dataset of loosely constructed sentences that is now ready to be analyzed.

### Text Analysis
##### Word frequency plots

The wordcloud shown at the head of this page is plotted from the entire corpus of posts and comments parsed from r/technology. The "name entities"  are apparent once we look past the high frequency generic words. These are apparent in the first histogram. The second histogram shows how the upvotes correlate with the name entities.

  <img src="https://github.com/ApurvaNaik/textMiningReddit/raw/master/img/ewf.png" alt="entity frequency" width="50%", align = "middle"><img src="https://github.com/ApurvaNaik/textMiningReddit/raw/master/img/tUpvotes.png" alt="general word frequency" width="50%", align = "middle">

It is interesting that people have mentioned "internet" and "government" most frequently yet, those posts are not the most upvoted. On the other hand, posts or comments mentioning brands have more upvotes, probably because these posts express an opinion about the brand that others relate to.

Next, I correlated upvotes with the number of posts containing the keywords (*I will refer to name entities as keywords now on*). This gave me an idea which keywords among others elicited the most response. Both number of posts and number of upvotes have been scaled to the range(0,1) for easy comparison.

<img src="https://github.com/ApurvaNaik/textMiningReddit/raw/master/img/prop.png" alt="general word frequency" width="70%", align = "right">

 "google" and "comcast" has nearly equal proportion of posts and upvotes. "reddit" is mentioned the least number of times whereas "government" and "internet" got the least upvotes. This confirms my suspicion that people don't upvote texts containing generic words. From the yellow histogram, its seen that "reddit" is the second least frequent word, yet text containing it is the 4th highest upvoted. This probably indicates reddit co-occurs with another more voted keyword.
 ```
 "...the only good thing about comcast is since they're in the news and on the front page of reddit so often that i have constant reminders to pay my bill."

"reddit is awesome.  they love that apple is fighting to encrypt phones, but then when they find out it can inconvenience them they grab the pitchforks."
 ```

### Quick and dirty sentiment analysis
Now that I know what the technology community at Reddit is talking about, I'm interested in knowing their opinion. There are a number of ways of doing this, varying in complexity. This time I have used the bag-of-words model.

```
In the bag-of-words feature, the text to be analyzed is literally shred into individual words (called tokens) and collected in a "bag of words". The Naive Bayes Classifier then compares words in this bag to those in two other bags labeled "Positive" and "Negative". The words in our bag are then labeled positive or negative, thus implying the sentiment.
```
The {tm.sentiment.plugin} package in R is well suited for this purpose. In addition to sentiment score it also tells us "polarity" (is the sentiment associated positive or negative?) and "subjectivity" (how much sentiment does the entity garner?) scores. This package is based on "Lydia",  an opinion mining methodology developed by Dr. Steven Skiena at Stony Brook University. More information is available in this [paper](http://www3.cs.stonybrook.edu/~skiena/lydia/37720161.pdf).

I chose to mine r/technology's opinion regarding the companies, Google, Apple, Comcast, and the idea of encryption.

##### Average Sentiment

The dark blue points in the boxplot show the very positive and negative sentiment scores. The light blue ones highlight where the popular opinion lies. It is apparent that Comcast and Apple elicit some extreme opinions, where as popular opinion about google and encryption (to some extent) is more balanced.

<img src="https://github.com/ApurvaNaik/textMiningReddit/raw/master/img/boxplot.png" alt="entity frequency" width="50%", align = "middle"><img src="https://github.com/ApurvaNaik/textMiningReddit/raw/master/img/meanSenti.png" alt="entity frequency" width="50%", align = "middle">

From the histogram, it is clear Google gets the most positive sentiment while Comcast gets the least.

#### Reddit hates Comcast

Being a seasoned redditor, I'm not surprised to find Comcast facing the community's wrath. there have been numerous topics of discussion. One redditor summarises the hate succintly. You can read more in [this thread](https://www.reddit.com/r/OutOfTheLoop/comments/26r31d/why_does_everyone_hate_comcast/?sort=top).

 What I did find surprising was Comcast getting some of the most positive scores. There's definitely a story here, so I went back to the scores and traced the texts that got the highest positive scores. I found two texts
```
"dear comcast"
"enjoy it while you can comcast."
```
Now I know what happened! The model was unable to detect sarcasm. Anyway, The model has correctly identified the sentiment and a few outliers donot affect the accuracy. It is possible however, to reduce the outliers even more by simply having a larger corpus of text for analysis.

#### More wordclouds

Below are the wordclouds generated from texts containing the respective keywords. It was fun plotting them in different shapes and colors. I even colored some of them in Photoshop.

*Google*
![Alt text](https://github.com/ApurvaNaik/textMiningReddit/raw/master/img/googleWC.png)

*Apple*
![Alt text](https://github.com/ApurvaNaik/textMiningReddit/raw/master/img/appleWC.png)

*encryption*
![Alt text](https://github.com/ApurvaNaik/textMiningReddit/raw/master/img/encryptionWC.png)


#### Concluding Remarks
Parsing comments from Reddit and analyzing them was interesting. r/technology loves talking about Google, Apple, Comcast and encryption. It loves Apple for taking a stand for encryption and hates Comcast unconditionally. Google appears more in a search engine context than as a company.

In the future I would love to analyze not just single words but combination of 2 or 3 words. It would also be interesting to do some juxtaposition analysis: finding which entities co-occur with, each other and how popular opinion shifts in such situations.
