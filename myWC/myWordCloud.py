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

d = path.dirname(__file__)

# Read the whole text.
text = open(path.join(d, 'words.txt')).read()

# Generate a word cloud image
wordcloud = WordCloud(stopwords = "im", width=1600, height=800).generate(text)

# Open a plot of the generated image.
plt.imshow(wordcloud)
plt.axis("off")
plt.tight_layout(pad=0)
plt.show()
