# import all necessary libraries

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns


# as data is in the form of excel, use read_excel command

df=pd.read_excel('E:\Python\Finance\Finance data/Bank_Personal_Loan_Modelling.xlsx',1)
df.head()

df.shape

df.columns

import plotly.express as px

fig=px.box(df,y=['Age', 'Experience', 'Income', 'Family', 'CCAvg'])
fig.show()


# Five point summary suggest that Experience has negative value(This should be fixed).
   # we can see the Min, Max, mean and std deviation for all key attributes of the dataset income has too much noise and slightly skewed right, Age and exp are equally distributed.
    
df.hist(figsize=(20,20))


# INFERENCE from Histogram
    #1.Age & Experience are to an extent equally distributed
    #2.Income & Credit card spending are skewed to the left
    #3.We have more Undergraduates than Graduate and Advanced & Professional
    #4.60% of customers have enabled online banking and went digital
    
sns.distplot(df['Experience'])

df['Experience'].mean()

Negative_exp=df[df['Experience']<0]
Negative_exp.head()

sns.distplot(Negative_exp['Age'])

Negative_exp['Experience'].mean()

Negative_exp.size

print('There are {} records which has negative values for experience, approx {} %'.format(Negative_exp.size , ((Negative_exp.size/df.size)*100)))

data=df.copy()

data.head()


# use numpy where function to change the negative values to mean value derived from data with the same age group

data['Experience']=np.where(data['Experience']<0, data['Experience'].mean(), data['Experience'])
data.head()

data[data['Experience']<0]


# co-relation of data

df.corr()

df.to_excel(r'E:\Python\Finance\Code image\Loan detail.xlsx',index=False)

plt.figure(figsize=(12,8))
sns.heatmap(df.corr(),annot=True)


# We could see that Age & Experience are very strongly correlated,
  # Hence it is fine for us to go with Age and drop Experience to avoid multi-colinearity issue.

data=data.drop(['Experience'],axis=1)
data.head()

# Grading based on mark
data['Education'].unique()

def mark(x):
    if x==1:
        return 'Undergrad'
    elif x==2:
        return 'Graduate'
    else:
        return 'Advanced/Professional'
    
data['Edu_mark']=data['Education'].apply(mark)
data.head()

data.to_excel(r'E:\Python\Finance\Code image\Edu_mark.xlsx',index=False)

Edu_dis=data.groupby('Edu_mark')['Age'].count()
Edu_dis.head()

fig=px.pie(data,values=Edu_dis,names=Edu_dis.index,title='Pie chart')
fig.show()


# Inference :We could see that We have more Undergraduates 41.92% than graduates(28.06%) & Advanced Professional(30.02%)
# Explore the account holder distribution

data.columns

def Security_CD(row):
    if(row['Securities Account']==1) & (row['CD Account']==1):
        return 'Holds Securites & Deposit'
    elif(row['Securities Account']==0) & (row['CD Account']==0):
        return 'Does not Holds Securites & Deposit'
    elif(row['Securities Account']==1) & (row['CD Account']==0):
        return 'Holds only Securites'
    elif(row['Securities Account']==0) & (row['CD Account']==1):
        return 'Holds only Deposit'
    
data['Account_holder_category']=data.apply(Security_CD,axis=1)
data.head()

values=data['Account_holder_category'].value_counts()
values.index 

data.columns

px.box(data,x='Education',y='Income',facet_col='Personal Loan')


# Customers Who have availed personal loan seem to have higher income than those who do not have personal loan

plt.figure(figsize=(12,8))
sns.distplot(data[data['Personal Loan']==0]['Income'],hist=False,label='Income with no personal loan')
sns.distplot(data[data['Personal Loan']==1]['Income'],hist=False,label='Income with personal loan')
plt.legend()


def plot(col1,col2,label1,label2,title):
    plt.figure(figsize=(12,8))
    sns.distplot(data[data[col2]==0][col1],hist=False,label=label1)
    sns.distplot(data[data[col2]==1][col1],hist=False,label=label2)
    plt.legend()
    plt.title(title)

plot('Income','Personal Loan','Income with no personal loan','Income with personal loan','Income Distribution')

plot('CCAvg','Personal Loan','Credit card avg no personal loan','Credit card avg personal loan','Credit card avg Distribution')

plot('Mortgage','Personal Loan','Mortgage of customers with no personal loan','Mortgage of customers with personal loan','Mortgage of customers Distribution')


# People with high mortgage value, i.e more than 400K have availed personal Loan

data.columns

col_names=['Securities Account','Online','Account_holder_category','CreditCard']

for i in col_names:
    plt.figure(figsize=(12,8))
    sns.countplot(x=i,hue='Personal Loan',data=data)
    

# How Age of a person is going to be a factor in availing loan ?, Does Income of a person have an impact on availing loan ?, Does the family size makes them to avail loan ?

sns.scatterplot(data['Age'],data['Personal Loan'],hue=data['Family'])

import scipy.stats as stats

Ho='Age does not have impact on availing personal loan'
Ha='Age does have impact on availing personal loan'

Age_no=np.array(data[data['Personal Loan']==0]['Age'])
Age_yes=np.array(data[data['Personal Loan']==1]['Age'])

t,p_value=stats.ttest_ind(Age_no,Age_yes,axis=0)
if p_value<0.05:
    print(Ha, 'as the p_value is less than 0.05 with a value of {}'.format(p_value))
else:
    print(Ho, 'as the p_value is Greater than 0.05 with a value of {}'.format(p_value))

    
# automate above stuffs

def Hypothesis(col1,col2,Ho,Ha):
    arr1=np.array(data[data[col1]==0][col2])
    arr2=np.array(data[data[col1]==1][col2])
    t,p_value=stats.ttest_ind(arr1,arr2,axis=0)
    if p_value<0.05:
        print('{} as the p_value is less than 0.05 with a value of {}'.format(Ha,p_value))
    else:
        print(' {} as the p_value is Greater than 0.05 with a value of {}'.format(Ho,p_value))
    
Hypothesis('Personal Loan','Age',Ho='Age does not have impact on availing personal loan',Ha='Age does have impact on availing personal loan')


# Income of a person has significant impact on availing Personal Loan or not?
Hypothesis(col1='Personal Loan',col2='Income',Ho='Income does not have impact on availing personal loan',Ha='Income does have impact on availing personal loan')    


# Number of persons in the family has significant impact on availing Personal Loan or not?
Hypothesis('Personal Loan','Family',Ho='Family does not have impact on availing personal loan',Ha='Family does have impact on availing personal loan')
