# Reading in libraries
import os
import pandas as pd
import numpy as np

# TODO: Update to github link later
# url = 'https://raw.githubusercontent.com/gongos/ESOMAR-Summer-Academy/master'
# df = pd.read_csv(url + '/DataCleaning/data.csv')

os.chdir('P:/Marketing_PR/Conferences/Gongos Enterprise/ESOMAR/ESOMAR Summer Academy 2017_Amsterdam/Workshop')

# Read in data to a pandas dataframe
df = pd.read_csv('Data/movie_metadata.csv')

# Using the dir function we can look at more details about python objects
# This gives us access to possible methods to access and manipulate information
dir(df)

# Access to documentation is available in the interpreter
# Use the 'help' function to view documentation
help(df.columns)

# There are a number of other useful functions for getting to know our data
df.shape
df.head()
df.head(25)
df.columns

# We can also look at specific data
# Data can be indexed a few different ways

# One column
df['director_name']

# Multiple columns
df[ ['movie_title', 'budget'] ]

# Filter on a condition
df[df['country'] == 'USA']

# Chain them together
df[df['country'] == 'USA']['movie_title']

# Look at unique values
df['director_name'].unique()

# Row 5039 looks like missing data
# Finding missing data is important in determining data quality
# Filter using functions
pd.isnull(df['director_name'])

# Rows that are null
df[ pd.isnull(df['director_name']) ]

# Rows that are not null
df[ -pd.isnull(df['director_name']) ]

# Look at incidence of certain variables
df['country'].value_counts()

# Recode some data
# Lets make a flag for color films
df['color'].unique()

# Transform variable using lambda
df['movie_facebook_likes'].apply(lambda x: x / 1000)

# Build flag applying a simple function
def color_recode(val):
    if val == 'Color':
        return 1
    else:
        return 0

# This should return 1
color_recode('Color')

# This should return 0
color_recode('test')
color_recode('Black and White')
color_recode(9)
color_recode(500)

# Actually recode the variable
df['color_dummy'] = df['color'].apply(color_recode)

# Build flag using lambda (dummy)
df['color'].apply(lambda x: 1 if x == 'Color' else 0)

# Build flag applying a complex function
def fb_like_recode(val):
    """
    This functions should take a variable and recode like so:
    If value = 0, return 0
    If value is 1-166 return 1
    If value is 167-3000 return 2
    If value is over 3000 return 3
    """

    if val == 0:
        return 0

    elif val <= 166:
        return 1

    elif val <= 3000:
        return 2

    elif val > 3000:
        return 3

df['grouped_movie_facebook_likes'] = df['movie_facebook_likes'].apply(fb_like_recode)

# Replace using pandas
fb_like_replace = {
    0: 'none',
    1: 'low',
    2: 'mid',
    3: 'high'
}

df['grouped_movie_facebook_likes_cat'] = df['grouped_movie_facebook_likes'].replace(fb_like_replace)

# Other notable functions in pandas
# Compare the two to find out if the recoding worked correctly
pd.crosstab(df['grouped_movie_facebook_likes'], df['grouped_movie_facebook_likes_cat'])
