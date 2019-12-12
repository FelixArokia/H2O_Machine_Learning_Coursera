#############################################################
####################     Artificial Data   ##################
#############################################################

rm(list = ls())
library(h2o)
h2o.init(strict_version_check = FALSE)
N = 1:1000
bloodTypes = c("A", "A", "A", "O", "O", "O", "AB", "B")
d <- data.frame(id = N)
d$bloodType <- bloodTypes[(d$id %% length(bloodTypes)) + 1]
str(d)
d$bloodType <- as.factor(d$bloodType)
d$age <- runif(N, min = 18, max = 65)

### health score between 0 and 9 with mean at 5
v = round(rnorm(N, mean=5, sd = 2))
summary(v)
v = pmax(v,0) #  checks for each element of the vector
v = pmin(v, 9) # checks for each element of the vector
summary(v)
table(v)

d$healthyEating <- v

### Lifestyle score between 0 and 9 with mean at 5
v = round(rnorm(N, mean=5, sd = 2))
summary(v)
### kids get a bonus
v <- v + ifelse(d$age < 30, 1, 0)
v = pmax(v,0) #  checks for each element of the vector
v = pmin(v, 9)
summary(v)
table(v)
d$activeLifestyle<- v

### New column - Add gender

v <- sample(c('M','F'), max(N), replace = TRUE)
d$gender <- v

d$gender <- as.factor(d$gender)

#### Salary

v <- 20000 + (d$age * 3) ^ 2
20000 + (18*3) ^ 2 # 22916 - MIN
20000 + (65*3) ^ 2 # 58025 - MAX
v <- v + d$healthyEating * 500 
v <- v - d$activeLifestyle * 500 # may be they are taking vacations, injured more etc
v <- v + runif(N, 0, 5000)
d$income = round(v, -2) #round to the nearest 100


as.h2o(d, destination_frame = "people_for_assignment")
### if data is already present in H2O environment

### WE CAN REFERENCE IT HERE. IT DOESNT DOWNLOAD IT. WE SIMPLY REFERENCE IT BY THE FOLLOWING

people_h2o <- h2o.getFrame("people_for_assignment")
summary(people_h2o)


all_cols <- names(people_h2o)
x_cols <- all_cols[!all_cols %in% c("id", "income")]
y_col <- "income"

parts <- h2o.splitFrame(people_h2o, ratios = c(0.8,0.1),
                        destination_frames = c("assignment_train",
                                               "assignment_valid",
                                               "assignment_test"))

train = parts[[1]]
valid = parts[[2]]
test  = parts[[3]]


#######################################################################
#####                        GBM Default                          #####
#######################################################################

mGBM_default <- h2o.gbm(x_cols, y_col, train, nfolds = 10, validation_frame = valid )

h2o.performance(mGBM_default, train = TRUE)
h2o.performance(mGBM_default, valid = TRUE)
h2o.performance(mGBM_default, xval  = TRUE)
h2o.performance(mGBM_default, newdata  = test)

#######################################################################
#####                        GBM Overfit                          #####
#######################################################################

mGBM_overfit <- h2o.gbm(x_cols, y_col, train, nfolds = 10, validation_frame = valid,
                        ntrees = 2000, #changed to 2000 trees
                        max_depth = 20)

h2o.performance(mGBM_overfit, train = TRUE)
h2o.performance(mGBM_overfit, valid = TRUE)
h2o.performance(mGBM_overfit, xval  = TRUE)
h2o.performance(mGBM_overfit, newdata  = test)
