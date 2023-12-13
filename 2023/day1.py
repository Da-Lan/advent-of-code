import os
import requests
import pandas as pd

import re
from pathlib import Path


##############################
# Functions
##############################

def f(s):
    s_sub = ""
    for c in s:
        s_sub = s_sub + c
        for key in NUM_DICT.keys():
            s_sub = s_sub.replace(key, NUM_DICT[key])
    return s_sub


def f_reverse(s):
    s_sub = ""
    for c in reversed(s):
        s_sub = c + s_sub
        for key in NUM_DICT.keys():
            s_sub = s_sub.replace(key, NUM_DICT[key])
    return s_sub


##############################
# Global variables
##############################

NUM_DICT = {"one": "1",
            "two": "2",
            "three": "3",
            "four": "4",
            "five": "5",
            "six": "6",
            "seven": "7",
            "eight": "8",
            "nine": "9"}

##############################
# Load data
##############################

day = "1"

# define file path to download at locally
root = Path(__file__).parent.resolve()
print(root)
filename = "".join(("day", day, ".csv"))
filepath = (os.path.join(root, filename))

url = "".join(("https://adventofcode.com/2023/day/", day, "/input"))

# read session cookie
with open(os.path.join(root, 'session_cookie.txt'), 'r') as file:
    session_cookie = file.read().rstrip()

# download data
r = requests.get(url, cookies={"session": session_cookie})
f = open(filepath, "w+")
f.write(r.text)
f.close()

print("Got day", day, "data into", filepath)

##############################
# Extract solution 1
##############################

df = pd.read_csv(filepath, header=None)
df = df.rename(columns={0: "col"})

df["col"] = df["col"].apply(lambda x: re.findall("[0-9]", x)[0] \
                                      + re.findall("[0-9]", x)[-1])
df["col"] = df["col"].astype(int)

print("Solution 1 :", df["col"].sum())

##############################
# Extract solution 2
##############################

df = pd.read_csv(filepath, header=None)
df = df.rename(columns={0: "col"})

df["col2"] = df["col"].apply(f)
df["col2_reverse"] = df["col"].apply(f_reverse)

df["col2_concat"] = df[["col2", "col2_reverse"]].apply(lambda x: re.findall("[0-9]", x[0])[0] \
                                                                 + re.findall("[0-9]", x[1])[-1], 1)
df["col2_concat"] = df["col2_concat"].astype(int)

print("Solution 2 :", df["col2_concat"].sum())
