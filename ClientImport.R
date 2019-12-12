###### IMPORTING FROM CLIENT   #######


h2o.init(strict_version_check = FALSE)

## instead of h2o.importfile

### create a dataset in R session and send it to H2O

x = seq(0,10,0.01)

y = jitter(sin(x), 1000)

plot(x,y)

sineWave = data.frame(a = x, b = y)

sineWave.h2o = as.h2o(sineWave)

sineWave.h2o

tail(sineWave.h2o)

## go to Flow and see what it looks like

df <- as.data.frame(sineWave.h2o)


