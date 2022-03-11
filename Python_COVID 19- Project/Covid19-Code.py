import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import os
import plotly.graph_objects as go
import plotly.express as px

files = os.listdir('E:\Python\Covid-19\Covid-19')
files

def read_data(path, filename):
    return pd.read_csv(path +'/'+ filename)

path='E:\Python\Covid-19\Covid-19'
world_data=read_data(path,'worldometer_data.csv')

day_wise=read_data(path,files[2])

group_data=read_data(path,files[3])

usa_data=read_data(path,files[4])

province_data=read_data(path,files[1])

province_data.shape

world_data.head()


# Which Country has maximum Total cases, Deaths, Recovered & active cases 

world_data.columns

columns=['TotalCases', 'TotalDeaths', 'TotalRecovered', 'ActiveCases']
for i in columns:
    fig=px.treemap(world_data.iloc[0:20],values=i,path=['Country/Region'],title="<b>TreeMap representation of different Countries w.r.t. their {}</b>".format(i))
    fig.show()

day_wise.head()


# what is the trend of Confirmed Deaths Recovered Active cases

fig=px.line(day_wise,x="Date",y=['Confirmed', 'Deaths', 'Recovered', 'Active'],title="covid cases w.r.t. date",template="plotly_dark")
fig.show()


# 20 most effected countries in BarPlot Representation of Population to Tests Done Ratio

pop_test_ratio=world_data['Population']/world_data['TotalTests'].iloc[0:20]

pop_test_ratio

fig=px.bar(world_data.iloc[0:20],x='Country/Region',y=pop_test_ratio[0:20],color='Country/Region',title='pop to done test ratio')
fig.show()


 # 20 countries that are badly affected w.r.t Time

world_data.columns

px.bar(world_data.iloc[0:20],x='Country/Region',y=['Serious,Critical','TotalDeaths','TotalRecovered','ActiveCases','TotalCases'],title='Current condition cases')

world_data.columns

fig.update_layout({'title':"Coronavirus cases w.r.t. time"})
fig.show()


# Top 20 countries of Total Confirmed Cases, Total Recovered Cases, Total Deaths,Total Active Cases

world_data.head()

world_data['Country/Region'].nunique()


# Top 20 countries of Total Confirmed cases

fig=px.bar(world_data.iloc[0:10],y='Country/Region',x='TotalCases',color='TotalCases',text='TotalCases')
fig.update_layout(template='plotly_dark',title_text='Top 20 countries of Total confirmed cases')
fig.show()

# Top 20 countries of Total Deaths

fig=px.bar(world_data.iloc[0:5].sort_values(by='TotalDeaths',ascending=False),y='Country/Region',x='TotalDeaths',color='TotalDeaths',text='TotalDeaths')
fig.update_layout(template='plotly_dark',title_text="Top 5 countries of Total Deaths cases")
fig.show()

# Top 20 countries of Total Active

fig=px.bar(world_data.iloc[0:5].sort_values(by='ActiveCases',ascending=False),y='Country/Region',x='ActiveCases',color='ActiveCases',text='ActiveCases')
fig.update_layout(template='plotly_dark',title_text="Top 5 countries of Total Active Cases")
fig.show()

# Top 20 countries of Total Recovered

fig=px.bar(world_data.iloc[0:5].sort_values(by='TotalRecovered',ascending=False),y='Country/Region',x='TotalRecovered',color='TotalRecovered',text='TotalRecovered')
fig.update_layout(template='plotly_dark',title_text="Top 5 countries of Total Recovered")
fig.show()

world_data.columns


# Pie Chart Representation of stats of worst affected countries

lables=world_data[0:10]['Country/Region'].values
cases=['TotalCases','TotalDeaths','TotalRecovered','ActiveCases']
for i in cases:
    fig=px.pie(world_data[0:10],values=i,names=lables,hole=0.5,title="{} Recordeded w.r.t. to WHO Region of 15 worst effected countries ".format(i))
    fig.show()


# Deaths to Confirmed ratio

deaths_to_confirmed=((world_data['TotalDeaths']/world_data['TotalCases']))
fig = px.bar(world_data,x='Country/Region',y=deaths_to_confirmed)
fig.update_layout(title={'text':"Death to confirmed ratio of some  worst effected countries",'xanchor':'left'},template="plotly_dark")
fig.show()

# Deaths to recovered ratio

deaths_to_recovered=((world_data['TotalDeaths']/world_data['TotalRecovered']))
fig = px.bar(world_data,x='Country/Region',y=deaths_to_recovered)
fig.update_layout(title={'text':"Death to recovered ratio of some  worst effected countries",'xanchor':'left'},template="plotly_dark")
fig.show()

# Tests to Confirmed Ratio

tests_to_confirmed=((world_data['TotalTests']/world_data['TotalCases']))
fig = px.bar(world_data,x='Country/Region',y=tests_to_confirmed)
fig.update_layout(title={'text':"Tests to confirmed ratio of some  worst effected countries",'xanchor':'left'},template="plotly_dark")
fig.show()

# Serious to Deaths Ratio

serious_to_death=((world_data['Serious,Critical']/world_data['TotalDeaths']))
fig = px.bar(world_data,x='Country/Region',y=serious_to_death)
fig.update_layout(title={'text':"serious to Death ratio of some  worst effected countries",'xanchor':'left'},template="plotly_dark")
fig.show()


# Visualize Confirmed,  Active,  Recovered , Deaths Cases(entire statistics ) of a particular country
  
group_data.head()

from plotly.subplots import make_subplots 
import plotly.graph_objects as go

def country_visualization(df,country):
    data=df[df['Country/Region']==country]
    
    data2=data.loc[:,['Date','Confirmed','Active', 'Recovered', 'Deaths']]
    
    fig=make_subplots(rows=1, cols=4, subplot_titles=("Confirmed", "Active", "Recovered","Deaths"))
    
    fig.add_trace(
    go.Scatter(name="Confirmed",x=data2['Date'],y=data2['Confirmed']),row=1, col=1
    )
    fig.add_trace(
    go.Scatter(name="Active",x=data2['Date'],y=data2['Active']),row=1, col=2
    )
    fig.add_trace(
    go.Scatter(name="Recovered",x=data['Date'],y=data2['Recovered']),row=1, col=3
    )
    fig.add_trace(
    go.Scatter(name="Deaths",x=data2['Date'],y=data2['Deaths']),row=1, col=4
    )
    
    fig.update_layout(height=600, width=1000, title_text='Date Vs Recorded case of {}'.format(country),template='plotly_dark')
    fig.show()
    
country_visualization(group_data,'India')