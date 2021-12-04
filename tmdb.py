#!/usr/bin/env python
# coding: utf-8

import pandas as pd
import requests
import json
import config

response_list = []
API_KEY = config.api_key

for movie_id in range(550,556):
    r = requests.get('https://api.themoviedb.org/3/movie/{}?api_key={}'.format(movie_id, API_KEY))
    response_list.append(r.json())

df = pd.DataFrame.from_dict(response_list)
genres_list = df['genres'].tolist()
flat_list = [item for sublist in genres_list for item in sublist]

result = []
for l in genres_list:
    r = []
    for d in l:
        r.append(d['name'])
    result.append(r)
df = df.assign(genres_all=result)

df_genres = pd.DataFrame.from_records(flat_list).drop_duplicates()

df_columns = ['budget', 'id', 'imdb_id', 'original_title', 'release_date', 'revenue', 'runtime']
df_genre_columns = df_genres['name'].to_list()
df_columns.extend(df_genre_columns)
s = df['genres_all'].explode()
df = df.join(pd.crosstab(s.index, s))

df['release_date'] = pd.to_datetime(df['release_date'])
df['day'] = df['release_date'].dt.day
df['month'] = df['release_date'].dt.month
df['year'] = df['release_date'].dt.year
df['day_of_week'] = df['release_date'].dt.day_name()
df_time_columns = ['id', 'release_date', 'day', 'month', 'year', 'day_of_week']

df[df_columns].to_csv('tmdb_movies_fact_table.csv')
df_genres.to_csv('tmdb_genres_dimension_table.csv')
df[df_time_columns].to_csv('tmdb_datetimes_dimension_table.csv')









