rm(list=ls())
setwd('/Users/xavierhoenner/Work/marvl-data-atlas')

#### Load up libraries
library(RPostgreSQL)

#### Load driver and open connection to the database
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname = "harvest", host = 'po.aodn.org.au', user = 'admin', port = '5432', password = 'admin')



#### Unload driver and disconnect from the database
dbDisconnect(con)
dbUnloadDriver(drv)