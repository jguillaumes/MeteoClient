# 
# Processing the weather HDF5 files in R
#
# This script opens an HDF5 file and makes a plot of day/night 
# average temperature from the "daily" dataset contained inside
# the file.
#

# Required libraries to read and process the HDF5 files
library(hdf5r)
library(nanotime)
library(dplyr)
library(ggplot2)

#+
# Change the dayTime indicator from an integer (1=day, 0=night) to a 
# string. It will be converted to a factor when loaded into a data.frame
#-
dayTimeName <- function(x) {
  if (x['daytime']==1)
    return("Day")
  else
    return("Night")
}

#+
# Open the HDF5 file
#-
f0 <- H5File$new(filename = '../data/monthly-201805.hdf5', mode = 'r')

#+
# The dataset block0 contains the dates in interger64 format
#-
d0 <- f0$open('daily/block0_values')
c0 <- f0$open('daily/block0_items')

#+
# The dataset block1 contains the floating point varianles:
# temperature, pressure, light and humidity
#-
d1 <- f0$open('daily/block1_values')
c1 <- f0$open('daily/block1_items')

#+
# The dataset block2 contains the integer variables:
# daytime indicator and count of records
#-
d2 <- f0$open('daily/block2_values')
c2 <- f0$open('daily/block2_items')

#+
# Convert the integer64 nanotimes to POSIXct, based on UTC,
# and put the result into an array
#-
a0 <- as.POSIXct(nanotime(d0$read()),tz='UTC')

#+
# Put the float and integer values into arrays
#-
a1 <- (d1$read())
a2 <- (d2$read())

# +
# Convert the arrays to data.frames and add the column names
# which are in the xxxx_items datasets in the HDF5 file
#-
df0 <- data.frame(a0)
colnames(df0) <- c0$read() 
df1 <- data.frame(t(a1))
colnames(df1) <- c1$read() 
df2 <- data.frame(t(a2))
colnames(df2) <- c2$read() 

#+
# Bind the three data frames to build an unified one with all the
# data.
#-
f <- cbind(df0,df1,df2)

#+
# Convert the datatime indicator to a factor.
# Convert to wide format, selection just the temperature
#-
f <- dplyr::mutate(f,daytime=as.factor(apply(f,1,dayTimeName)))
fw <- reshape(data = f, direction = 'wide', idvar=c('date'),timevar='daytime',
               drop=c('light','pressure','humidity','count'))

#+
# Add a column with the difference between day and night temperatures
# Convert back to long format
#-
fw <- mutate(fw, temperature.Difference = temperature.Day - temperature.Night)
fw2 <- reshape(fw,direction = 'long', varying=c('temperature.Day','temperature.Night','temperature.Difference'))

#+
# Prepare and draw a plot
#-
plt <- ggplot(data = fw2) + geom_line(aes(x=date,y=temperature,group=time,color=time))
plot(plt)

