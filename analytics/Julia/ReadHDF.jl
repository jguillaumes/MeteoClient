#
# Processing the weather HDF5 files in Julia 1.0
#
# This script opens an HDF5 file and creates DataFrame objects for the three
# datasets it contains. It also makes a plot of day/night
# average temperature from the "daily" dataset.
#

using HDF5
using Base.Filesystem
using DataFrames
using CategoricalArrays
using Gadfly
using Dates

#+
# Change this variables to point to the HDF file you want to process
#-
filePath = relpath("../data")
fileName = "monthly-201808.hdf5"

#+
# Open the hdf5 file
#-
h5f = h5open(joinpath(filePath,fileName),"r")

#+
# Extract references to the data and labes for the rawdata dataset
#-
dr0  = h5f["rawdata/block0_values"] # Floats dataset
dr1  = h5f["rawdata/block1_values"] # integer64 (datetime) dataset
dr0n = h5f["rawdata/block0_items"]
dr1n = h5f["rawdata/block1_items"]

#+
# Create DataFrames for the block0 (floats) and block1 (integer64 containing
# times in nanosecods). Note the tick used to transpose the read matrices.
# Build an array with the field labels from both datasets.
#-
dfr0 = DataFrame(read(dr0)')
dfr1 = DataFrame(read(dr1)')
drn  = vcat(read(dr1n),read(dr0n))

#+
# Concatenate both DataFrames and assign the column names.
#-
dfr = hcat(dfr1,dfr0)
names!(dfr,Symbol.(drn))

#+
# Convert the interger64 values to proper times. Remember those
# times are UTC, but the Julia datatime is plain (has no TZ info)
#-
dfr[:time] = unix2datetime.(div.(dfr[:time],1000000000))


#+
# Extract references to the data and labes for the hourly dataset
#-
dh0 =  h5f["hourly/block0_values"] # Floats dataset
dh1  = h5f["hourly/block1_values"] # integer dataset (count)
dh2  = h5f["hourly/block2_values"] # integer64 dataset (time)
dh0n = h5f["hourly/block0_items"]
dh1n = h5f["hourly/block1_items"]
dh2n = h5f["hourly/block2_items"]

#+
# Create dataframes from the dataset contents and prepare an
# array with the field labels
#
dfh0 = DataFrame(read(dh0)')
dfh1 = DataFrame(read(dh1)')
dfh2 = DataFrame(read(dh2)')
dfn = vcat(read(dh0n), read(dh1n), read(dh2n))

#+
# Concatenate the datasets, assign column names and convert int64 to datetime
#-
dfh = hcat(dfh0,dfh1,dfh2)
names!(dfh,Symbol.(dfn))
dfh[:time] = unix2datetime.(div.(dfh[:time],1000000000))

#+
# Get references for the daily datasets (contents and labels)
#-
dd0 = h5f["daily/block0_values"] # Integer64 (datetime)
dd1 = h5f["daily/block1_values"] # Floats
dd2 = h5f["daily/block2_values"] # Integers (count and daylight indicator)
dd0n = h5f["daily/block0_items"]
dd1n = h5f["daily/block1_items"]
dd2n = h5f["daily/block2_items"]

#+
# Create DataFrames and label array
#-
dfd0 = DataFrame(read(dd0)')
dfd1 = DataFrame(read(dd1)')
dfd2 = DataFrame(read(dd2)')
ddn = vcat(read(dd0n), read(dd1n), read(dd2n))

#+
# Concatenate dataframes, add column labels and convert datetime
#-
dfd = hcat(dfd0,dfd1,dfd2)
names!(dfd,Symbol.(ddn))
dfd[:date] = unix2datetime.(div.(dfd[:date],1000000000))

#+
# Convert the integer daytime indicator to a categorical, descriptive
# variable.
#-
dfd[:daytime] = CategoricalArray(map(x-> if x==1 return "Day" else return "Night" end , dfd[:daytime]))

#+
# Unstack the data, extracting just the temperature, so we have the day
# and night temperatures in the same row. Discard days with incomplete
# data and add a day-night difference column.
#-
dfdu = dropmissing!(unstack(dfd,[:date],:daytime,:temperature))
dfdu[:Difference] = dfdu[:Day] - dfdu[:Night]

#+
# Stack again the dataframe so we can use Gadfly to plot it.
#-
dfdt = stack(dfdu,[:Day,:Night,:Difference], variable_name=:daytime, value_name=:temperature)
plot(dfdt,x=:date,y=:temperature,color=:daytime,Geom.line)
