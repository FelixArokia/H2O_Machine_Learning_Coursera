#install.packages("h2o")

library(h2o)


#h2o.init() # throwing the following error: Version mismatch! H2O is running version 3.26.0.8 but h2o-R package is version 3.26.0.2.
           # Install the matching h2o-R version from - http://h2o-release.s3.amazonaws.com/h2o/rel-yau/8/index.html

h2o.init(strict_version_check = FALSE)

url <- "http://h2o-public-test-data.s3.amazonaws.com/smalldata/iris/iris_wheader.csv"

iris <- h2o.importFile(url)

str(iris) #class H2O frame - felix

parts = h2o.splitFrame(iris, 0.8)

str(parts) # contains a list of two h2o data frames
head(parts)

train <- parts[[1]]
test <- parts[[2]]

summary(train)

nrow(train)
nrow(test)

#####################################################################################
#######                         DEEP LEARNING                                 #######
#####################################################################################

mDL <- h2o.deeplearning(1:4, 5, train)

mDL

pred <- h2o.predict(object = mDL, newdata = test )

pred

h2o.performance(model = mDL, newdata = test)

#####################################################################################
#######                               AUTO ML                                 #######
#####################################################################################

mA = h2o.automl(1:4, 5, train, max_runtime_secs = 30) ### default is 1 hour

mA
mA@leaderboard
as.data.frame(mA@leaderboard)

pred_aML <- h2o.predict(mA@leader, test)

h2o.performance(model = mA@leader, newdata = test)

### even though train data has mean class error of 0, the performance on test data is 
### NOT 0, meaning it did slightly poorly in test


### Auto ML takes 15% of the training data for validation and another 15% for leader board.
### So effectively it takes only 70% of 80% which is 56% of the data for training and NOT 80%


## the way H2O works is you don't tell it what type of model you want to build. 
## You tell it which column is your answer column and that's referred to as Y, 
## the letter Y. So, if your answer column is numeric, H2O will build a regression model.
## If it's enum column also called a factor or a categorical column, it will do a classification
## And if there's only two options in that column, it will make a binomial 
## otherwise it's making a multinomial.

str(train)
## so here we can see that the last column "class" is a factor



#####################################################################################
#######                             QUESTIONS                                 #######
#####################################################################################

# 1) What is Hit Ratio and why do we have 3 rows there
# 2) What is rmse, mse and logloss metrics in a multi-nomial classification
# 3) Does AutoML give an ensemble as a model in the leaderboard
# 4) Is 15% for validation and 15% for leaderboard still holds good in current version




