# Song analytics

import pandas as pd
from datetime import datetime
 
wdir = r'E:\Projects\02 Web Scraping Project'
env = 'data/clean'
wdirF = wdir + '/' + env + '/'

songs = pd.read_csv(wdirF + 'swr3-songs-2016-v2.csv')

# Create timestamp from 'date' and 'time' columns, then remove the latter two
songs['ts'] = songs.apply(lambda row: datetime.strptime(row['date'] + ' ' + row['time'], '%d.%m.%Y %H:%M'), axis=1)
songs = songs[['ts', 'title', 'artist']]
songs.sort_values(by='ts', inplace=True)

# Create more date and time variables
songs['day'] = songs.apply(lambda row: row['ts'].day, axis=1)
songs['month'] = songs.apply(lambda row: row['ts'].month, axis=1)
songs['year'] = songs.apply(lambda row: row['ts'].year, axis=1)

songs['weekday'] = songs.apply(lambda row: row['ts'].isoweekday(), axis=1)
songs['week'] = songs.apply(lambda row: row['ts'].week, axis=1)
songs['quarter'] = songs.apply(lambda row: row['ts'].quarter, axis=1)

songs['hour'] = songs.apply(lambda row: row['ts'].hour, axis=1)
songs['minute'] = songs.apply(lambda row: row['ts'].minute, axis=1)

print(songs.head())