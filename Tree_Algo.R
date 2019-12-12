############  Decision Trees  ############

## So, although explainability is often given as a good reason to use decision trees
## and the other tree algorithms we'll look at this week. In practice, realistic examples 
## tend to be large complex and so the tree diagrams themselves tend to be large complex
## and not that helpful for explainability. 

##But anyway, let's go on to look at some enhancements of the decision tree idea.


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
#######                         RANDOM FOREST                                 #######
#####################################################################################

mRF = h2o.randomForest(1:4, 5, train)

mRF ## see model summary, 50 trees etc. read about all the parameters here

pred = h2o.predict(object = mRF, newdata = test)

h2o.performance(mRF, test)


#####################################################################################
#######                              GBM                                      #######
#####################################################################################
## GBMs are a bit like random forests. They're an ensemble, a set of trees working together
## But whereas random forest got the variety between the trees by cutting away some columns,
## cutting away some rows, GBM works by boosting certain rows for each tree, giving each row
## in your training data a different weight for each tree.

## And you can see eventually, if you have one really difficult training row, 
## all the trees keep getting wrong. Eventually, it's going to get boosted and boosted
## until it gets a dedicated tree

## That may not happen especially not with large datasets, but conceptually,
## that's what's happening.

## The good side, GBMs can deal really well with non-linearity in your data, awkward data.

## The downside, is it's also going to try and learn all the noise in your data. So, when
## using GBMs, they're very powerful technique but do take extra care to watch out
## for overfitting.

## to generalize predictions we can see the following

# http://docs.h2o.ai/h2o/latest-stable/h2o-docs/booklets/GBMBooklet.pdf

# search for "generali"

# 1) we can change n_bins_cat which is random binning for categorical factors
# 2) we can change depth of the tree
# 3) we can reduce the learning rate but it is inversely proportional to trees. more trees will be built





mGBM = h2o.gbm(1:4, 5, train)

mGBM

### GBM's are generally shallow in tree depth compared to RF's

pred = h2o.predict(mGBM, test)

h2o.performance(mGBM, test)

#####################################################################################
#######                             QUESTIONS                                 #######
#####################################################################################

## 1) What is hit ratio
##    Ans: The hit ratio is a table representing the number of times that the prediction 
##         was correct out of the total number of predictions.

## 2) What is k in hit ratio ?????

## 3) Each tree is built in parallel in H2O for GBM. how is that possible ?
##    http://docs.h2o.ai/h2o/latest-stable/h2o-docs/data-science/gbm.html?highlight=gbm%20model%20generalization






