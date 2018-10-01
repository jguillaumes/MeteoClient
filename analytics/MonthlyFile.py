
# coding: utf-8

# # Get a monthly file from database
# 
# This program gets the observations corresponding to a month passed by parameter and builds an HDF file containing them. The parameter is passed in the format ```YYYYMM``` where ```YYYY``` is the year and ```M``` is the month.
# 

# In[4]:


import sys
import sqlalchemy as sql
import pandas as pd
import datetime as dt

dbUrl    = 'postgres://weather:weather@ct01.jguillaumes.dyndns.org/weather'
sqlQuery = 'select time at time zone \'utc\' as time, temperature, pressure, humidity, light from weather where time between %(initial)s and %(final)s' 
dbConn   = sql.create_engine(dbUrl)

if len(sys.argv) != 2:
    print('Please specify the month to process as a line argument, format YYYYMM')
    exit
else:
    monthParam = sys.argv[1]


# ## Function to get the first and last days of the month to extract

# In[5]:


def computeLimits(m):
    inYear  = m[0:4]
    inMonth = m[4:6]
    lastDays = {1:31,2:28,3:31,4:30,5:31,6:30,7:31,8:31,9:30,10:31,11:30,12:31}
    
    nInYear = int(inYear)
    nInMonth= int(inMonth)
    
    day1    = dt.datetime(nInYear,nInMonth,1,tzinfo=dt.timezone.utc)
    lastDay = lastDays[nInMonth]
    if nInMonth == 2:
        nYear = int(inYear)
        if nYear % 4 == 0 and nYear % 100 != 0:
            lastDay = 29
    dayL    = dt.datetime(nInYear,nInMonth,lastDay,
                          hour=23,minute=59,second=59,microsecond=999999,
                          tzinfo=dt.timezone.utc)
    return day1, dayL


# In[6]:


initial, final = computeLimits(monthParam)
params = {'initial': initial, 'final': final}
data = pd.read_sql_query(sqlQuery, dbConn, params=params).set_index('time')
fileName = f'monthly-{monthParam}.hdf5'
data.to_hdf(fileName,key='rawdata',mode='a',complevel=5)
print('*** {0} raw rows saved in the hdf file.'.format(len(data)))


# ## Prepare the daily summaries
# 
# Summarize by date and distinguish between day and night observations
# The criteria we will use is the value of the light reading. Values under 50 will be considered night.

# In[8]:


data['daytime'] = data.apply(lambda x: 'Day' if x['light'] > 50 else 'Night', axis=1)
byday = data.to_period('D').reset_index().groupby(['time','daytime']).agg(
    {'time':'size',
     'temperature':'mean',
     'pressure': 'mean',
     'humidity':'mean',
    'light':'mean'}
 )
byday.columns=['count','temperature','pressure','humidity','light']
byday = byday.reset_index().set_index(['time','daytime'])
byday.to_hdf(fileName,key='daily',mode='a',complevel=5)
print('*** {0} daily summary rows saved in the hdf file.'.format(len(byday)))


# ## Prepare the hourly summaries
# 
# Summarize by hour

# In[9]:


byhour = data.to_period('H').reset_index().groupby('time').agg(
    {'time':'size',
    'temperature':'mean',
    'pressure':'mean',
    'humidity':'mean',
    'light':'mean'}
)
byhour.columns=['count','temperature','pressure','humidity','light']
byhour = byhour.reset_index().set_index('time')
byhour.to_hdf(fileName,key='hourly',mode='a',complevel=5)
print('*** {0} hourly summary rows saved in the hdf file.'.format(len(byhour)))


# In[10]:


print('*** Process ended.')

