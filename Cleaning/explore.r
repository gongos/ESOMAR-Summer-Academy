## ESOMAR EDA
## Updated: 050917

# can click the Run button above or CTRL+ENTER to run a line of code
# highlight multiple lines at once to run them together



# read in the data and save it as a data frame
# NOTE: removed data.frame around this
df <- read.csv("P:/Marketing_PR/Conferences/Gongos Enterprise/ESOMAR/ESOMAR Summer Academy 2017_Amsterdam/Materials/Data/movie_metadata.csv")
df = read.csv("P:/Marketing_PR/Conferences/Gongos Enterprise/ESOMAR/ESOMAR Summer Academy 2017_Amsterdam/Materials/Data/movie_metadata.csv")

# you can read files from urls, filepaths, or uploading them to the RStudio environment

# Look at the data
df

# Head and tail of data - default is top/bottom 6 rows and column headers
# To filter it down so it is easier to see
head(df)
tail(df)

# check the number of rows and columns
nrow(df)
ncol(df)

# Pull a list of those columns
colnames(df)

# install and load a library to investigate variables - you only need to install the first time you use a library
# after that, you only need to load it each time you use it - libraries are usually installed at the top of a file
install.packages("dplyr")
install.package('psych')

library(dplyr)
library(psych)

# to look at a specific variable in the file, use $ after the data frame name to call it
df$genres

# Can also index using square brackets [rows, columns]
df[, 'genres']
df[1:10, 'genres']

describe(df$genres)

# to look at all vars at once
describe(df)

# look at the range of years
range(df$title_year)
# it says NA to NA

# to find help when using a function
?range()

# documentation says default doesn't remove the NAs
# to limit the range to fields with values, include na.rm=TRUE (remove the NAs)
range(df$title_year, na.rm=TRUE)

# Create a variable that groups movie facebook likes into categories
# look at how they are distributed
summary(df$movie_facebook_likes)
boxplot(df$movie_facebook_likes)

# We will recode to these values
# 0: none
# 1: low
# 2: mid
# 3: high

# adding it to the df using $ notation
# if else, checks for the condition, does the first thing if statement is true, second if not
df$grouped_movie_fb_likes = NA
df$grouped_movie_fb_likes = ifelse(df$movie_facebook_likes==0,0,df$grouped_movie_fb_likes)
df$grouped_movie_fb_likes = ifelse(df$movie_facebook_likes<=166 & df$movie_facebook_likes>0,1,df$grouped_movie_fb_likes)
df$grouped_movie_fb_likes = ifelse(df$movie_facebook_likes>166 & df$movie_facebook_likes<=3000,2,df$grouped_movie_fb_likes)
df$grouped_movie_fb_likes = ifelse(df$movie_facebook_likes>3000,3,df$grouped_movie_fb_likes)

# look at the counts for each category
table(df$grouped_movie_fb_likes)

# we can recode these to high, medium, low, and none (row, column notation)
df[df[,"grouped_movie_fb_likes"]==0, "grouped_movie_fb_likes_cat"] = "none"
df[df[,"grouped_movie_fb_likes"]==1, "grouped_movie_fb_likes_cat"] = "low"
df[df[,"grouped_movie_fb_likes"]==2, "grouped_movie_fb_likes_cat"] = "mid"
df[df[,"grouped_movie_fb_likes"]==3, "grouped_movie_fb_likes_cat"] = "high"

table(df$grouped_movie_fb_likes)

# Another way to recode
df$grouped_movie_fb_likes_cat = recode(df$grouped_movie_fb_likes,
  `0`='none',`1`='low', `2`='mid', `3`='high')
