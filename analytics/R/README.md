# R examples and tools

This directory contains several examples of R code to exploit the HDF5 files
containing the weather observations.

## Contained files and examples

- **ReadHDF.R**: how to process the hdf5 files to get the three datasets they
contain, annotated and used to draw a basic plot.

- **GetDataFrame.R**: Ready to use functions to extract the raw, daily and hourly
datasets from the hdf5 files.

- **PlotMinMaxTemp.ipynb**: How to generate a plot with the minimum and maximum
temperatures per day. Uses GetDataFrame.R and is, as you can deduce from the
name, a Jupyter notebook.

## Requirements

These programs have been tested using R 3.4.4. The following packages are
required and should be present to run the examples:

- hdf5r
- dplyr
- nanotime
- reshape
- ggplot2
