library(plyr) # data manipulation
library(stringr) # text data manipulation
library(devtools)  
library(tm.plugin.sentiment) # sentiment analysis
library(ggplot2) # data visualization
library(ggthemes) # data visualization
library(dplyr) # data manipulation
library(purrr)  
library(scales) # brewer_pal
library(reshape2) # melt function
library(RCurl) # pull .csv from url

link = "https://raw.githubusercontent.com/ApurvaNaik/Firefly-observations-Data-Analysis/master/data/firefly.data1.csv"
x = getURL(link)
data = readLines(textConnection(x))

# remove duplicate rows
data <- unique(data)
text.clean = gsub('[[:punct:]]', '', data)
# convert into a corpus
text.corpus <- VCorpus(VectorSource(text.clean))
# format text
text = tm_map(text.corpus, content_transformer(tolower))
text = tm_map(text, removeNumbers)
text = tm_map(text, removeWords, stopwords("SMART"))
remove_stopwords = c("like","dont", "know", "can","edit","even","get","going", "just","make","need","new","now","one","really","see","still","time","use","want","way","will")
text = tm_map(text, removeWords, c("like","dont", "know", "can","edit","even","get","going", "just","make","need","new","now","one","really","see","still","time","use","want","way","will"))
text = tm_map(text, removePunctuation)
text = tm_map(text, stripWhitespace)
# convert again to corpus, since performing the transformations corrupts the meta data of the original corpus
text.corpus = VCorpus(VectorSource(text))
df = data.frame(text=unlist(sapply(text, `[`, "content")), stringsAsFactors=F)

# Wordcloud
# create document term matrix applying some transformations
tdm = TermDocumentMatrix(text.corpus, control = list(removePunctuation = TRUE, stopwords = remove_stopwords, stopwords("SMART"), removeNumbers = TRUE, tolower = TRUE))
# define tdm as matrix
m = as.matrix(tdm)
# get word counts in decreasing order
word_freqs = sort(rowSums(m), decreasing=TRUE)
word_freqs <- word_freqs[word_freqs > 11]
# create a data frame with words and their frequencies
dm = data.frame(word=names(word_freqs), freq=word_freqs)

# write to text file
words = as.vector(df[,1])
f = file("words.txt")
writeLines(words, f)
close(f)

# histogram of 8 most frequent words
dm_08 = dm[1:8, ]
l = mean(dm_08$freq)
pos = l-0.9*l
p = ggplot(dm_08, aes(x= reorder(word, freq), y = freq, width = 0.7)) + geom_bar(data = dm_08, stat = "identity", fill="deepskyblue", colour="black") + xlab("word") + ylab("frequency of appearance") + geom_text(aes(label = freq, y = pos), size = 4, color = "white") + theme_few()
p + theme(axis.line=element_blank(),axis.text.y=element_blank(),axis.ticks=element_blank(), axis.title.x=element_blank(), panel.border=element_blank(), text = element_text(size=15), axis.text.x = element_text(angle=45, vjust=1.4, hjust = 1.1))
dev.off()

# histogram of 8 most talked about entities
dm_en = data.frame(word = c("internet", "government", "google", "apple", "comcast", "encryption", "reddit", "facebook"), freq = c("789", "693", "530", "496", "430", "401", "319", "257"))
dm_en$freq = as.numeric(as.character(dm_en$freq))
dm_en[,1]=as.character(dm_en[,1])
n = mean(dm_en$freq)
pos = n-0.9*n
p = ggplot(dm_en, aes(x= reorder(word, freq), y = freq, width = 0.9)) + geom_bar(data = dm_en, stat = "identity", fill="#91204D") + xlab("word") + ylab("frequency of appearance") + geom_text(aes(label = freq, y = pos), color = "white") + theme_minimal()
p + theme(axis.line=element_blank(),axis.text.y=element_blank(),axis.ticks=element_blank(), axis.title.x=element_blank(), panel.border=element_blank(), text = element_text(size=15), axis.text.x = element_text(angle=45, vjust=1.4, hjust = 1.1))

dev.off()

# read csv file
link = "https://raw.githubusercontent.com/ApurvaNaik/Firefly-observations-Data-Analysis/master/data/firefly.data1.csv"
y = getURL(link)
data.csv = read.csv(textConnection(y), header = F, stringsAsFactors = F)
data.csv = as.data.frame(data.csv)

# convert to lowercase
data.csv = data.frame(lapply(data.csv, function(v) {
  if (is.character(v)) return(tolower(v))
  else return(v)
}))

data.csv = na.omit(data.csv)
# get comment by keyword from.csv, eg. comcast
# for loop to do them all at once
for (i in 1:nrow(dm_en)) {
    assign(paste0("filter.", dm_en$word[[i]]), filter(data.csv, grepl(dm_en$word[[i]], data.csv$V1)))
    print(paste0("done writing filter.", dm_en$word[[i]]))
}

# write df to entity|upvote and plot histogram
sum(filter.internet$V3)
sum(filter.apple$V3)
sum(filter.government$V3)
sum(filter.google$V3)
sum(filter.comcast$V3)
sum(filter.encryption$V3)
sum(filter.reddit$V3)
sum(filter.facebook$V3)

upvotes = data.frame(entity = c("internet", "government", "google", "apple", "comcast", "encryption", "reddit", "facebook"), upvotes = c("148986", "57988", "297959", "320233", "234389", "103516", "175833", "106467"), stringsAsFactors = F)
upvotes[,2]= as.numeric(upvotes[,2])
r = mean(upvotes$upvotes)
pos = r-0.9*r
p = ggplot(upvotes, aes(x= reorder(entity, upvotes), y = upvotes)) + geom_bar(data = upvotes, stat = "identity", fill="#E8BF56") + xlab("entity") + ylab("total upvotes for all comments") + geom_text(aes(label = upvotes, y = pos), size = 4, color = "white") + theme_minimal()
p + theme(axis.line=element_blank(),axis.text.y=element_blank(),axis.ticks=element_blank(), axis.title.x=element_blank(), panel.border=element_blank(), text = element_text(size=15), axis.text.x = element_text(angle=45, vjust=1.4, hjust = 1.1))

# filter.apple$ncomments <-seq.int(nrow(filter.apple))
# i <- sapply(filter.apple, is.factor)
# filter.apple[i] <- lapply(filter.apple[i], as.character)

# calculate number of unique posts in filter.apple, filter.google
# better script would have a function instead of repeating the same block of code
post.apple = rep("1", nrow(filter.apple))
for(i in 1:nrow(filter.apple)){
  post.apple[i] = grepl(filter.apple[i+1,1], filter.apple[i,1])
}
post.apple = na.omit(post.apple)
sum(post.apple == "FALSE")

post.google = rep("1", nrow(filter.google))
for(i in 1:nrow(filter.apple)){
  post.google[i] = grepl(filter.google[i+1,1], filter.google[i,1])
}
post.google = na.omit(post.google)
sum(post.google == "FALSE")

post.comcast = rep("1", nrow(filter.comcast))
for(i in 1:nrow(filter.apple)){
  post.comcast[i] = grepl(filter.comcast[i+1,1], filter.comcast[i,1])
}
post.comcast = na.omit(post.comcast)
sum(post.comcast == "FALSE")

post.reddit = rep("1", nrow(filter.reddit))
for(i in 1:nrow(filter.apple)){
  post.reddit[i] = grepl(filter.reddit[i+1,1], filter.reddit[i,1])
}
post.reddit = na.omit(post.reddit)
sum(post.reddit == "FALSE")

post.internet = rep("1", nrow(filter.internet))
for(i in 1:nrow(filter.apple)){
  post.internet[i] = grepl(filter.internet[i+1,1], filter.internet[i,1])
}
post.internet = na.omit(post.internet)
sum(post.internet == "FALSE")

post.facebook = rep("1", nrow(filter.facebook))
for(i in 1:nrow(filter.apple)){
  post.facebook[i] = grepl(filter.facebook[i+1,1], filter.facebook[i,1])
}
post.facebook = na.omit(post.facebook)
sum(post.facebook == "FALSE")

post.encryption = rep("1", nrow(filter.encryption))
for(i in 1:nrow(filter.apple)){
  post.encryption[i] = grepl(filter.encryption[i+1,1], filter.encryption[i,1])
}
post.encryption = na.omit(post.encryption)
sum(post.encryption == "FALSE")

post.government = rep("1", nrow(filter.government))
for(i in 1:nrow(filter.apple)){
  post.government[i] = grepl(filter.government[i+1,1], filter.government[i,1])
}
post.government = na.omit(post.government)
sum(post.government == "FALSE")

npost = c("83", "77", "92","32","62","29","14","22")
upvotes = data.frame(upvotes,npost)
upvotes$npost = as.numeric(as.character(upvotes$npost))

# normalize nums for better comparison
scale.range = function(x){(x-min(x))/(max(x)-min(x))}
upvotes$snpost=scale.range(upvotes$npost)
upvotes$supvotes = scale.range(upvotes$upvotes)

# to remove columns
# upvotes[4:7]=list(NULL)

# plot stacked bar chart
scaled.upvotes = data.frame(entity = upvotes[,1],n.Posts = upvotes[,4], n.Upvotes = upvotes[,5])
scaled.upvotes = melt(scaled.upvotes)

p <- ggplot(scaled.upvotes,aes(x = reorder(entity, value), y = value,fill = variable)) + 
  geom_bar(position = "fill",stat = "identity", color = "black") + xlab("entity") + ylab("proportion of upvotes and number of top posts") + theme_minimal() +
  scale_y_continuous(labels = percent_format()) + scale_fill_manual(values = c("n.Posts" = "#E2F7CE", "n.Upvotes" = "#5D4157"))
p + theme(axis.ticks.x=element_blank(), axis.title.x=element_blank(), panel.border=element_blank(), text = element_text(size=13), axis.text.x = element_text(angle=45, vjust = 1.5, hjust =1.1))

# make df from data
df = data.frame(data, stringsAsFactors = F)
df = data.frame(lapply(df, function(v) {
  if (is.character(v)) return(tolower(v))
  else return(v)
}))

# filter by keyword and create corpus
text_filter = function(x, column, string){
   filter(x, grepl(string, x[, column]))
}

# clean text
clean_text = function(x, column){
  corpus <- Corpus(VectorSource(x[, column]))
  corpus  <- tm_map(corpus, PlainTextDocument)
  tm_map(corpus, removePunctuation)
  tm_map(corpus, removeNumbers)
  tm_map(corpus, removeWords, stopwords("SMART"))
}

# convert to dataframe
con_df = function(x) data.frame(text=unlist(sapply(x, `[`, "content")), stringsAsFactors=F)

#write to file
write_file=function(x, column, string){
  words <- as.vector(x[, column])
  f = file(paste0(string,".txt"))
  writeLines(words, f)
  close(f)
}

# sentiment analysis
df.google = readLines("google.txt")

text = VCorpus(VectorSource(df.google))
text = tm_map(text, removeNumbers)
text = tm_map(text, stripWhitespace)
text.score = score(text, control = list(removePunctuation = TRUE, removeNumbers = TRUE, stripWhitespace = TRUE, stemDocument = TRUE, minWordLength = 3, weighting = weightTf))
t = meta(text.score)
# qplot(data = t_col, score, geom = "histogram", xlab = "score", fill = positive, binwidth = 0.08, ylim = c(0,4000))

ggplot(data = t, aes(t$senti_diffs_per_ref)) + geom_histogram(breaks = seq(-0.3,0.3,by = 0.01), fill = "slateblue1", col = "black") + labs(title = "sentiment scores") + labs(x = "score", y = "count") + theme_few()

# calculate all sentiment scores and put them in one list
scores <- list(google = t.google[,5], apple = t.apple[,5], encryp = t.encryp[,5], comcast = t.comcast[,5])
d <- data.frame(x = unlist(scores), grp = rep(c("google", "apple", "encryp", "comcast"),times = sapply(scores,length)))
d$very_pos = as.numeric(d$x>=0.3)
d$very_neg = as.numeric(d$x<=-0.3)


cols = c("#3B8686", "#CFF09E", "#79BD9A", "#A8DBA8")
names(cols) = c("google", "apple", "encryp", "comcast")

# boxplot of scores
ggplot(d, aes(x=grp, y=x, group=grp)) +
  geom_boxplot(aes(fill=grp)) +
  scale_fill_manual(values=cols) +
  geom_jitter(colour="#0B486B", position=position_jitter(width=0.7), alpha=0.1)+ 
  ylab("score") + theme_minimal() + theme(axis.title.x=element_blank())

# find mean sentiment scores
meanscore = tapply(d$x, d$grp, mean)
df.mean = data.frame(entity = names(meanscore), meanscore = meanscore)
df.mean$entity <- reorder(df.mean$entity, df.mean$meanscore)

# barplot mean score by entity
ggplot(df.mean, aes(y = df.mean$meanscore)) + geom_bar(data = df.mean, stat = "identity", aes(x = entity, fill = entity)) + 
  scale_fill_manual(values=cols[order(df.mean$meanscore)]) + 
  ylab("mean sentiment score") + theme_minimal() + theme(axis.title.x = element_blank())