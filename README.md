# Weather sensors client software
This repository contains client software to read and process the information captured and transmitted by the gizmo
described in https://github.com/jguillaumes/MeteoArduino.

## Main software (client application)

This application listens to the information transmitted by the gizmo (via BlueTooth) and processes it. Currently it:

- Stores the raw data line into a text file
- Sends the collected data to a ElasticSearch cluster
- Stores the data in a postgresql database.
- Sets the RTC clock in the gizmo to the correct date and time on startup
-
The software is composed of the main program, ```weatherClient.py``` and the library components
contained in the ``weatherLib``` directory.

### Required python environment

This scripts require Python version **3.6 or greater**. They require the following python modules to be installed:

- pybluez
- pytz
- elasticsearch
- elasticsearch-dsl
- psycopg2
- sqlite3

Please note the current Raspbian distribution for the Raspberry pi platform **does not** include Python 3.6, nor there is (at the time of this writing) any installable 3.6 deb package. So, if you want to use these scripts you'll have to install 3.6 from sources. There are plenty of tutorials to do so; I used this one: http://www.knight-of-pi.org/installing-python3-6-on-a-raspberry-pi/

Please be sure to have ```sqlite3-dev``` installed before building python. You will probably also want to have ```libgdbm-dev``` and ```libncurses5-dev``` too.

## ```tools``` directory

This directory contains assorted tools to manipulate the elasticsearch and postgresql databases. They are not fully documented and are -mostly- one shot programs made to solve problems or to do massive loads or unloads of information.

Some of the scripts can be used as examples of how to do batch processing of elasticsearch contained data.

## ```analytics``` directory

This directory contains code to exploit the captured information to do statisctical analysis and7or plotting. Apart from the one-shot stuff the most important file here is ```MonthlyFile.py``` which extracts a month worth of information from the database and puts it in an hdf5 file to be processed later. The description of the hdf5 is in the ```./data``` subdirectory, and the generated files are published and available from google drive (look at the README.md file in the data directory for details)

The directory contains subdirectories (```./julia``` and ```./R```) with sample code to process the python-generated hdf5 files from those languages.
