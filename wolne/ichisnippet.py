from datetime import timedelta

high_9 = df['High'].rolling(window= 9).max()
low_9 = df['Low'].rolling(window= 9).min()
df['tenkan_sen'] = (high_9 + low_9) /2

high_26 = df['High'].rolling(window= 26).max()
low_26 = df['Low'].rolling(window= 26).min()
df['kijun_sen'] = (high_26 + low_26) /2

# this is to extend the 'df' in future for 26 days
# the 'df' here is numerical indexed df
last_index = df.iloc[-1:].index[0]
last_date = df['Date'].iloc[-1].date()
for i in range(26):
    df.loc[last_index+1 +i, 'Date'] = last_date + timedelta(days=i)

df['senkou_span_a'] = ((df['tenkan_sen'] + df['kijun_sen']) / 2).shift(26)

high_52 = df['High'].rolling(window= 52).max()
low_52 = df['Low'].rolling(window= 52).min()
df['senkou_span_b'] = ((high_52 + low_52) /2).shift(26)

# most charting softwares dont plot this line
df['chikou_span'] = df['Close'].shift(-22) #sometimes -26 

tmp = df[['Close','senkou_span_a','senkou_span_b','kijun_sen','tenkan_sen']].tail(300)
a1 = tmp.plot(figsize=(15,10))
a1.fill_between(tmp.index, tmp.senkou_span_a, tmp.senkou_span_b)
