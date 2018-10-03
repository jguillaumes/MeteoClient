# Weather sensor datasets

The data captured by the weather sensors is publicly available and can
be downloaded from:

https://drive.google.com/open?id=1abg4dVuky7ydBu0oEJv-WvUg1XJx8Mo3

The data comes in HDF5 files, one for each month of observations. The HDF5 files were generated using the Pandas python package, in *fixed* format. Their hyerarchical structure is as follows:

- file
  - daily
    - axis0: Dataframe column names
    - axis1: Dataframe row identifiers (numbers)
    - block0_items: columns contained in the block0
    - block0_values: values in block0
    - block1_items: columns contained in the block1
    - block1_values: values in block1
    - block2_items: columns contained in the block2
    - block2_values: values in block2
  - hourly
    - axis0: Dataframe column names
    - axis1: Dataframe row identifiers (numbers)
    - block0_items: columns contained in the block0
    - block0_values: values in block0
    - block1_items: columns contained in the block1
    - block1_values: values in block1
    - block2_items: columns contained in the block2
    - block2_values: values in block2
  - rawdata
  - axis0: Dataframe column names
  - axis1: Dataframe row identifiers (numbers)
    - block0_items: columns contained in the block0
    - block0_values: values in block0
    - block1_items: columns contained in the block1
    - block1_values: values in block1

The contents of each block are matrices of the same datatype. The list of columns for each dataset (contained in axis0) is:

- daily
  - date: observation date
  - daytime: indicator: 1 means day, 0 means night
  - count: number of observations for that day and daytime
  - temperature: average of temperature observations for that day and
  daytime, in centigrades
  - pressure: average of atmospheric pressure observations for that day and daytime, in hectopascals
  - humidity: average of the relative humidity observed on that day and daytime, in percentage
  - light: average of the readings of the light sensor for that day and daytime.

- hourly:
  - time: observation hour (begin of hour)
  - count: number of observations for that hour
  - temperature: average of temperature observations for that hour, in centigrades
  - pressure: average of atmospheric pressure observations for that hour, in hectopascals
  - humidity: average of the relative humidity observed on that hour, in percentage
  - light: average of the readings of the light sensor for that hour

- raw:
  - time: observation time
  - temperature: observed temperature, in centigrades,
  - pressure: observeda atmospheric pressure, in hectopascals
  - humidity: observed relative humidity, in percentage
  - light: light sensor reading

  The light reading is not calibrated nor corresponds to any physical unit. It is just a reference value and shouldn't be used in calculations apart from basic things like distinguishing day and night.

  The datasets can be read directly from python and render a complete pandas dataframe. You can find examples to read them in R and Julia in the ../R and ../Julia directories, respectively.

## License

This content is released under a BSD style license, which text follows.

Copyright 2018, Jordi Guillaumes i Pons

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.  
