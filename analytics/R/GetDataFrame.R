#+
# R Functions to read the weather datasets from the HDF5 files
#-

require(hdf5r)
require(dplyr)
require(nanotime)


#+
# The hdf5r library returns unidimensional datasets as lists and multidimensional
# ones as matrices, which variables in different rows. Those matrices must be transposed
# to be converted to dataframes.
# This function verifies if its argument is a matrix and, if this is the case, it returns
# it transposed.
#-
checkAndTranspose <- function(m) {
  if (is.null(dim(m)))
    return (m)
  else
    return (t(m))
}

#+
# Get the daily averages dataset from an hdf5 file
#-
getDailyDF <- function(file) {
  #+
  # Inner function to convert the daytime indicator from integer (0/1) to 
  # a string value ("Night"/"Day")
  #-
  dayTimeName <- function(x) {
    if (x['daytime']==1)
      return("Day")
    else
      return("Night")
  }
  
  #+
  # Open hdf5 file and data (_values) and labels (_items)
  # datasets.
  #-
  h5f <- H5File$new(filename = file, mode = 'r')
  d0 <- h5f$open('daily/block0_values')
  d1 <- h5f$open('daily/block1_values')
  d2 <- h5f$open('daily/block2_values')
  n0 <- h5f$open('daily/block0_items')
  n1 <- h5f$open('daily/block1_items')
  n2 <- h5f$open('daily/block2_items')
  
  #+
  # Read datasets containing values into matrices
  # (see the comment for checkAndTranspose())
  #-
  a0 <- checkAndTranspose(d0$read()) 
  a1 <- checkAndTranspose(d1$read())
  a2 <- checkAndTranspose(d2$read())
  
  #+
  # Convert the matrices to dataframes and add the
  # column labels
  #-
  df0 <- data.frame(a0)
  colnames(df0) <- n0$read() 
  df1 <- data.frame(a1)
  colnames(df1) <- n1$read() 
  df2 <- data.frame(a2)
  colnames(df2) <- n2$read() 
  
  #+
  # Combine the three dataframes into a global one.
  # Change the daytime column to a factor variable.
  # Change the date value from integer64 to proper time.
  #
  df <- cbind(df0,df1,df2)
  df <- mutate(df, daytime=apply(df,1,dayTimeName)) %>% mutate(daytime=as.factor(daytime)) %>%
        mutate(date=as.POSIXct(nanotime(df$date),tz='UTC'))
  h5f$close()
  return (df)
}
  
#+
# Get the hourly averages dataset from an hdf5 file
#-
getHourlyDF <- function(file) {
  #+
  # Open hdf5 file and data (_values) and labels (_items)
  # datasets.
  #-
  h5f <- H5File$new(filename = file, mode = 'r')
  d0 <- h5f$open('hourly/block0_values')
  d1 <- h5f$open('hourly/block1_values')
  d2 <- h5f$open('hourly/block2_values')
  n0 <- h5f$open('hourly/block0_items')
  n1 <- h5f$open('hourly/block1_items')
  n2 <- h5f$open('hourly/block2_items')
  
  #+
  # Read datasets containing values into matrices
  # (see the comment for checkAndTranspose())
  #-
  a0 <- checkAndTranspose(d0$read()) 
  a1 <- checkAndTranspose(d1$read())
  a2 <- checkAndTranspose(d2$read())
  
  #+
  # Convert the matrices to dataframes and add the
  # column labels
  #-
  df0 <- data.frame(a0)
  colnames(df0) <- n0$read() 
  df1 <- data.frame(a1)
  colnames(df1) <- n1$read() 
  df2 <- data.frame(a2)
  colnames(df2) <- n2$read() 
  
  #+
  # Combine the three dataframes into a global one.
  # Change the date value from integer64 to proper time.
  #
  df <- cbind(df0,df1,df2)
  df <- mutate(df, time=as.POSIXct(nanotime(df$time),tz='UTC'))
  h5f$close()
  return (df)
}

#+
# Get the raw observations dataset from an hdf5 file
#-
getRawDF <- function(file) {
  #+
  # Open hdf5 file and data (_values) and labels (_items)
  # datasets.
  #-
  h5f <- H5File$new(filename = file, mode = 'r')
  d0 <- h5f$open('rawdata/block0_values')
  d1 <- h5f$open('rawdata/block1_values')
  n0 <- h5f$open('rawdata/block0_items')
  n1 <- h5f$open('rawdata/block1_items')

  #+
  # Read datasets containing values into matrices
  # (see the comment for checkAndTranspose())
  #-
  a0 <- checkAndTranspose(d0$read()) 
  a1 <- checkAndTranspose(d1$read())

  #+
  # Convert the matrices to dataframes and add the
  # column labels
  #-
  df0 <- data.frame(a0)
  colnames(df0) <- n0$read() 
  df1 <- data.frame(a1)
  colnames(df1) <- n1$read() 

  #+
  # Combine the two dataframes into a global one.
  # Change the date value from integer64 to proper time.
  #
  df <- cbind(df0,df1)
  df <- mutate(df, time=as.POSIXct(nanotime(df$time),tz='UTC'))
  h5f$close()
  return (df)
}