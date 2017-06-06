## Data Analysis

# Data is already in the WS - you can see the df in the global environment
# Load a library we want to use
library(Hmisc)

# Let's build a linear model
# Look to see if the number of facebook likes for the movie and principal actors impacts sales
describe(df$gross)
# There is some missing data - we'll have to remove it to build a model

mod.df = df[!is.na(df[,'gross']),]
nrow(df)
5043-4159

# Look at the variables we want to use in the model
describe(mod.df$cast_total_facebook_likes)

describe(mod.df$actor_1_facebook_likes)
describe(mod.df$actor_2_facebook_likes)
describe(mod.df$actor_3_facebook_likes)
describe(mod.df$movie_facebook_likes)

# There are missing values in some of these variables - let's remove them
# Need to update our df to mod.df, so we don't reintroduce the removed gross values
mod.df = mod.df[!is.na(mod.df[,'actor_1_facebook_likes']), ]

# Try it with actor 2 and 3
mod.df = mod.df[!is.na(mod.df[,'actor_2_facebook_likes']), ]
mod.df = mod.df[!is.na(mod.df[,'actor_3_facebook_likes']), ]

nrow(mod.df)
# We have 4146 rows now


# Plot the variables against one another
plot(mod.df$gross,mod.df$cast_total_facebook_likes)

plot(mod.df$gross,mod.df$actor_1_facebook_likes)
plot(mod.df$gross,mod.df$actor_2_facebook_likes)
plot(mod.df$gross,mod.df$actor_3_facebook_likes)
plot(mod.df$gross,mod.df$movie_facebook_likes)
# Can click through these plots using arrows above the display

# Look at the correlations
corr_cols = c(
  'gross',
  'cast_total_facebook_likes',
  'actor_1_facebook_likes',
  'actor_2_facebook_likes',
  'actor_3_facebook_likes',
  'movie_facebook_likes'
  )
cor(mod.df[, corr_cols])

# Construct a linear model
model <- lm(gross~cast_total_facebook_likes + actor_1_facebook_likes + actor_2_facebook_likes + actor_3_facebook_likes + movie_facebook_likes, data=mod.df)

# Look at our model
summary(model)


# Let's do some cluster analysis
# Group things together based on their facebook likes

# Clean data to only rows with facebook likes
cluster.df = df[!is.na(df[,'movie_facebook_likes']),]
cluster.df = cluster.df[!is.na(cluster.df[,'actor_1_facebook_likes']),]

# Let's check that we removed the correct number of rows

# Build a 'base' to cluster on
base = data.frame(cluster.df$actor_1_facebook_likes,cluster.df$movie_facebook_likes)

# Group them in groups of 2, 3, 4, and 5
k2 = kmeans(base, 2)
k3 = kmeans(base, 3)
k4 = kmeans(base, 4)
k5 = kmeans(base, 5)

# Look at output
k2

# Assign cluster membership to the data frame
cluster.df$k2m = k2$cluster
cluster.df$k3m = k3$cluster
cluster.df$k4m = k4$cluster
cluster.df$k5m = k5$cluster

# Look at the plot
plot(cluster.df$actor_1_facebook_likes,cluster.df$movie_facebook_likes)

# Extreme outliers - let's limit our view
plot(cluster.df$actor_1_facebook_likes,cluster.df$movie_facebook_likes,xlim=c(0,55000),ylim=c(0,200000))

# VISUALIZE
# Plot cluster membership in colors against the facebook likes
install.packages("ggplot2")
library(ggplot2)

# This is grammar of graphics - the elements can be added piece by piece
plot = ggplot(cluster.df, aes(movie_facebook_likes,actor_1_facebook_likes)) + geom_point()
plot

# Color the points by cluster membership
plot = ggplot(cluster.df, aes(movie_facebook_likes,actor_1_facebook_likes)) + geom_point(aes(colour=k2m))
plot

# Limit to a better view
plot = ggplot(cluster.df, aes(movie_facebook_likes,actor_1_facebook_likes)) + geom_point(aes(colour=k2m)) +
  xlim(0,200000) + ylim(0,150000)
plot

# Looks like our clusters are split by movie likes
# Give it better labels
plot = ggplot(cluster.df, aes(movie_facebook_likes,actor_1_facebook_likes)) + geom_point(aes(colour=k2m)) +
  xlim(0,200000) + ylim(0,150000)+
  xlab("Movie Facebook Likes") + ylab("First Listed Actor Facebook Likes")
plot

# Add a title
plot = ggplot(cluster.df, aes(movie_facebook_likes,actor_1_facebook_likes)) + geom_point(aes(colour=k2m)) +
  xlim(0,200000) + ylim(0,150000)+
  xlab("Movie Facebook Likes") + ylab("First Listed Actor Facebook Likes") +
  ggtitle("Cluster Membership for Movie and Actor Facebook Likes")
plot

# Fix the legend so it's binary
# The data needs to be a factor to do this - recode to factor
cluster.df$k2m=as.factor(cluster.df$k2m)

plot = ggplot(cluster.df, aes(movie_facebook_likes,actor_1_facebook_likes)) + geom_point(aes(colour=k2m)) +
  xlim(0,200000) + ylim(0,150000)+
  xlab("Movie Facebook Likes") + ylab("First Listed Actor Facebook Likes") +
  ggtitle("Cluster Membership for Movie and Actor Facebook Likes")
plot


# Let's change the theme of the graph
plot = ggplot(cluster.df, aes(movie_facebook_likes,actor_1_facebook_likes)) + geom_point(aes(colour=k2m)) +
  xlim(0,200000) + ylim(0,150000)+
  xlab("Movie Facebook Likes") + ylab("First Listed Actor Facebook Likes") +
  ggtitle("Cluster Membership for Movie and Actor Facebook Likes") +
  theme_bw()
plot


# Remove the outer black box
plot = ggplot(cluster.df, aes(movie_facebook_likes,actor_1_facebook_likes)) + geom_point(aes(colour=k2m)) +
  xlim(0,200000) + ylim(0,150000)+
  xlab("Movie Facebook Likes") + ylab("First Listed Actor Facebook Likes") +
  ggtitle("Cluster Membership for Movie and Actor Facebook Likes") +
  theme(panel.background = element_blank())
plot

# Put x and y back
plot = ggplot(cluster.df, aes(movie_facebook_likes,actor_1_facebook_likes)) + geom_point(aes(colour=k2m)) +
  xlim(0,200000) + ylim(0,150000)+
  xlab("Movie Facebook Likes") + ylab("First Listed Actor Facebook Likes") +
  ggtitle("Cluster Membership for Movie and Actor Facebook Likes") +
  theme(panel.background = element_blank(),axis.line = element_line(colour = "black"))
plot


# Put minor grid lines back
plot = ggplot(cluster.df, aes(movie_facebook_likes,actor_1_facebook_likes)) + geom_point(aes(colour=k2m)) +
  xlim(0,200000) + ylim(0,150000)+
  xlab("Movie Facebook Likes") + ylab("First Listed Actor Facebook Likes") +
  ggtitle("Cluster Membership for Movie and Actor Facebook Likes") +
  theme(panel.background = element_blank(),axis.line = element_line(colour = "black"),panel.grid.minor = element_line(colour="gray"))
plot
