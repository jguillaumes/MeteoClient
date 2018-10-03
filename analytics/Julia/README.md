# Julia examples and tools

This directory contains several examples of Julia code to exploit the HDF5 files
containing the weather observations.

## Contained files and examples

- **ReadHDF.jl**: how to process the hdf5 files to get the three datasets they
contain, annotated and used to draw a basic plot.

- **GetDataFrame.jl**: Ready to use functions to extract the raw, daily and hourly
datasets from the hdf5 files.

- **PlotMinMaxTemp.ipynb**: How to generate a plot with the minimum and maximum
temperatures per day. Uses GetDataFrame.jl and is, as you can deduce from the
name, a Jupyter notebook.

## Requirements

These programs have been tested using Julia 1.0. The following packages are
required and should be present to run the examples:

- HDF5
- DataFrames
- Dates
- CategoricalArray
- Gadfly

At the moment of this writing, there is a problem with the relased version of
Gadfly and Julia 1.0. The master (HEAD) version in the github repository works.
To install it do as follows:

```
Pkg> add Gadfly#master
```
