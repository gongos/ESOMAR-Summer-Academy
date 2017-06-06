## ESOMAR EDA

# Can click the Run button above or CTRL+ENTER to run a line of code
# Highlight multiple lines at once to run them together



# Read in the data and save it
# You'll need to update the file path below - locate the data on your computer and insert the path
# Copying in the file path with have '\' - these need to be replaced with \\ or / in order to work
df <- read.csv("C:/Users/cgilbert/Desktop/movie_metadata.csv")
df = read.csv("C:/Users/cgilbert/Desktop/movie_metadata.csv")

# You can read files from urls, filepaths, or uploading them to the RStudio environment

# Look at the data
df

# Head and tail of data - default is top/bottom 6 rows and column headers
# To filter it down so it is easier to see
head(df)
tail(df)

# Check the number of rows and columns
nrow(df)
ncol(df)

# Pull a list of those columns
colnames(df)

# Install and load a library to investigate variables - you only need to install the first time you use a library
# After that, you only need to load it each time you use it - libraries are usually installed at the top of a file
install.packages("dplyr")
install.packages('psych')
install.packages('Hmisc')

library(dplyr)
library(psych)
library(Hmisc)

# To look at a specific variable in the file, use $ after the data frame name to call it
df$genres

# Can also index using square brackets [rows, columns]
df[, 'genres']
df[1:10, 'genres']

describe(df$genres)

# To look at all vars at once
describe(df)

# Look at the range of years
range(df$title_year)
# It says NA to NA

# To find help when using a function
?range()

# Documentation says default doesn't remove the NAs
# To limit the range to fields with values, include na.rm=TRUE (remove the NAs)
range(df$title_year, na.rm=TRUE)

# Create a variable that groups movie facebook likes into categories
# Look at how they are distributed
summary(df$movie_facebook_likes)
boxplot(df$movie_facebook_likes)

# We will recode to these values
# 0: none
# 1: low
# 2: mid
# 3: high

# Adding it to the df using $ notation
# If else, checks for the condition, does the first thing if statement is true, second if not
df$grouped_movie_fb_likes = NA
df$grouped_movie_fb_likes = ifelse(df$movie_facebook_likes==0,0,df$grouped_movie_fb_likes)
df$grouped_movie_fb_likes = ifelse(df$movie_facebook_likes<=166 & df$movie_facebook_likes>0,1,df$grouped_movie_fb_likes)
df$grouped_movie_fb_likes = ifelse(df$movie_facebook_likes>166 & df$movie_facebook_likes<=3000,2,df$grouped_movie_fb_likes)
df$grouped_movie_fb_likes = ifelse(df$movie_facebook_likes>3000,3,df$grouped_movie_fb_likes)

# Look at the counts for each category
table(df$grouped_movie_fb_likes)

# We can recode these to high, medium, low, and none (row, column notation)
df[df[,"grouped_movie_fb_likes"]==0, "grouped_movie_fb_likes_cat"] = "none"
df[df[,"grouped_movie_fb_likes"]==1, "grouped_movie_fb_likes_cat"] = "low"
df[df[,"grouped_movie_fb_likes"]==2, "grouped_movie_fb_likes_cat"] = "mid"
df[df[,"grouped_movie_fb_likes"]==3, "grouped_movie_fb_likes_cat"] = "high"

table(df$grouped_movie_fb_likes)

# Another way to recode
df$grouped_movie_fb_likes_cat = recode(df$grouped_movie_fb_likes,
  `0`='none',`1`='low', `2`='mid', `3`='high')
