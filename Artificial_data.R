####################     Artificial Data   ##################

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

#### Salary

v <- 20000 + (d$age * 3) ^ 2
20000 + (18*3) ^ 2 # 22916 - MIN

20000 + (65*3) ^ 2 # 58025 - MAX

v <- v + d$healthyEating * 500 

v <- v - d$activeLifestyle * 500 # may be they are taking vacations, injured more etc

v <- v + runif(N, 0, 5000)

d$income = round(v, -2) #round to the nearest 100

as.h2o(d, destination_frame = "people")


### if data is already present in H2O environment

### WE CAN REFERENCE IT HERE. IT DOESNT DOWNLOAD IT. WE SIMPLY REFERENCE IT BY THE FOLLOWING

people_h2o <- h2o.getFrame("people")
summary(people_h2o)
