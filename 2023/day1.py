import os
import requests
import pandas as pd

import re
from pathlib import Path

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

print("Solution :", df["col"].sum())