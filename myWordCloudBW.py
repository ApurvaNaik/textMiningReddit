#!/usr/bin/env python2
"""
Minimal Example
===============
Generating a square wordcloud from the US constitution using default arguments.
"""

from os import path
from wordcloud import WordCloud
import matplotlib.pyplot as plt
import csv
import random

def grey_color_func(word, font_size, position, orientation, random_state=None, **kwargs):
    return "hsl(0, 0%%, %d%%)" % random.randint(60, 100)

d = path.dirname(__file__)

# Read the whole text.
text = open(path.join(d, 'words.txt')).read()

# Generate a word cloud image
wordcloud = WordCloud(stopwords = "im", max_words=2000, width=1600, height=800).generate(text)

default_colors = wordcloud.to_array()
# Open a plot of the generated image.
# plt.imshow(wordcloud)
plt.imshow(wordcloud.recolor(color_func=grey_color_func, random_state=2))
plt.axis("off")
# plt.tight_layout(pad=0)
plt.show()
