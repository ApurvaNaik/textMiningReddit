# script to get top 4 comments from 100 top posts of the year

import praw, csv, sys, obot
reload(sys)
sys.setdefaultencoding('utf-8')

USERAGENT = "u/odumann test"
SUBREDDIT = "technology"
MAXPOSTS = None
obot.login()

r = praw.Reddit(USERAGENT)
sub = r.get_subreddit(SUBREDDIT)
post_generator = sub.get_top_from_year(limit = MAXPOSTS)
fname = 'comments_%s_none.csv' %SUBREDDIT

f = open(fname, "w")
writer = csv.writer(f, lineterminator = "\n")

for submission in post_generator:
    comments = submission.comments
    count = 0
    for comment in comments:
        if (count < 7):
            if not isinstance(comment, praw.objects.MoreComments):
                writer.writerow((comment.submission, comment.body, comment.score))
            count +=1
f.close()
