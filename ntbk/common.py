from datetime import time
from functools import reduce
import pandas as pd

def first_prep(df):


    df["datetime"] = pd.to_datetime(df.datetime)
    df["date"] = df.datetime.dt.date


    #TODO: turn times into parameters
    open_time = time(9, 0)
    close_time = time(17, 30)
    ibclose_time = time(10, 0)

    daily_open = df[df.datetime.dt.time == open_time][["date", "open"]]
    daily_close = df[df.datetime.dt.time == close_time][["date", "close"]]
    ib_close = df[df.datetime.dt.time == ibclose_time][["date", "close"]].rename(
        columns={"close" : "ibclose"}
    )
    daily_low = df.groupby("date").low.min().reset_index()
    daily_high = df.groupby("date").high.max().reset_index()

    ib_low = df[df.datetime.dt.time <= ibclose_time].groupby("date").low.min().reset_index().rename(columns={"low" : "iblow"})
    ib_high = df[df.datetime.dt.time <= ibclose_time].groupby("date").high.max().reset_index().rename(columns={"high" : "ibhigh"})

    data = reduce(
        lambda l, r: pd.merge(l, r, on="date"),
        [daily_open, daily_close, daily_high, daily_low, ib_low, ib_high, ib_close]
    )

    data["daydir"] = data.apply(
        lambda r: "up" if r.close >= r.open else "down",
        axis=1
    )

    data["ibdir"] = data.apply(
        lambda r: "up" if r.ibclose >= r.open else "down",
        axis=1
    )

    return data


class GannSwing:
    def __init__(self, first="up", h="high", l="low",
                   h1="high_lag_1", h2="high_lag_2",
                   l1="low_lag_1", l2="low_lag_2"):
        self.prev = first
        self.h = h
        self.l = l
        self.h1 = h1
        self.h2 = h2
        self.l1 = l1
        self.l2 = l2

    def __call__(self, r):
        if r[self.h] >= r[self.h1] >= r[self.h2]:
            s = "up"
        elif r[self.l] <= r[self.l1] <= r[self.l2]:
            s = "down"
        else:
            s = self.prev
        self.prev = s
        return s


def get_lags(df, c, n):
    for i in range(1, n+1):
        df[c + "_lag_" + str(i)] = df[c].shift(i)


            
def cokolwiek():
    pass
