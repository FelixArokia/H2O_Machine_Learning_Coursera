#########################################################################
#######                       DATA MANIPULATION                    ######
#########################################################################


library(h2o)
h2o.init(strict_version_check = FALSE)

url = "http://h2o-public-test-data.s3.amazonaws.com/smalldata/airlines/allyears2k_headers.zip"

data_h2o <- h2o.importFile(url)


#data[, "xxx"] <- as.factor(data[, "xxx"])

#Column Stats
mean(data[, "AirTime"])
summary(data[, "AirTime"])

mean(data[, "AirTime"], na.rm = TRUE)

h2o.mean(data[, "AirTime"]) #gives an NAN as base package mean

h2o.mean(data[, "AirTime"], na.rm = TRUE)

range(data[, "AirTime"], na.rm = TRUE)

hist(data[, "AirTime"]) ### THIS THROWS AN ERROR

h2o.hist(data[, "AirTime"])

h2o.hist(data[, "ArrDelay"])

names(data) ## Working

### working of any and all

h2o.any() # gives a true of false if the condition written inside retrieves any row
h2o.summary(data[, "ArrDelay"])
h2o.any(data[, "ArrDelay"] > 480)
h2o.any(data[, "ArrDelay"] < 480)
h2o.any(h2o.na_omit(data[, "ArrDelay"]) > 350) #does not have na condition so


h2o.all() # gives a true or false if all of the data is retrieved for this condition
h2o.all(data[, "ArrDelay"] < 480)  #everything is less than 480 but because of NA condition gives FALSE
h2o.all(h2o.na_omit(data[, "ArrDelay"]) < 480) # now its true

h2o.cumsum(data[, "ArrDelay"], axis = 0) # column sum (takes all rows of a column above the given row)
h2o.cumsum(data[, "ArrDelay"], axis = 1) # row sum (takes all columns in a row)


h2o.cor(data[, "AirTime"], data[, "ArrDelay"], na.rm = TRUE)

#lets try 3 columns 

v_col_names <- names(data)

corr_col_names <- v_col_names[6:8]

summary(data[, corr_col_names])

h2o.cor(data[, corr_col_names], na.rm = TRUE)

corr_col_names <- v_col_names

h2o.cor(data[, corr_col_names], na.rm = TRUE) #NOT WORKING IF I PUT ALL COLUMN NAMES

cor(data[, "AirTime"], data[, "ArrDelay"], na.rm  = TRUE) #base also works

data("mtcars")

cor(mtcars)
cor(data, na.rm = TRUE) ### ALL COLUMNS DONT WORK


