NAMES_DOMAINS = "MOCK_DATA.txt"
ADDRESSES = "Addresses.in"
OUTPUT = "Shops.sql"

OPENING_HOURS = "Lun-Dom: 10 - 20"
IMAGE_PATH = "img/1.JPG"

HEADER = "insert into Shop (name,website,address,lat,lon,openingHours,userId,imagePath) values\n"

URL_MAPS = "https://maps.googleapis.com/maps/api/geocode/json"

MAX_DEPTH = 5

import requests
from random import randint

def get_coords(address, depth=1, max_depth=1):
    try:
        location = requests.get(URL_MAPS, params={"sensor": "false", "address": address}).json()['results'][0]['geometry']['location']
        coords = [str(location['lat']), str(location['lng'])]
    except:
        if depth < max_depth:
            coords = get_coords(address, depth=depth + 1, max_depth=max_depth)
        else:
            coords = ["0", "0"]
    return coords

fin = open(NAMES_DOMAINS, "r")
shops = [x.split("\t") for x in fin.read().split("\n")]
fin.close()

fin = open(ADDRESSES, "r")
for i in range(len(shops)):
    line = "\n"
    while line == "\n":
        line = fin.readline()
    shops[i].append(line.replace("\n", ""))
fin.close()

fout = open(OUTPUT, "w")
fout.write(HEADER)
for i in range(len(shops)):
    print(i)
    coords = get_coords(shops[i][2], max_depth=5)
    id_user = str(randint(10, 50))
    footer = ","
    if i == len(shops) - 1:
        footer = ";"
    fout.write("    (\"" + shops[i][0] + "\",\"" + shops[i][1] + "\",\"" + shops[i][2] + "\"," + coords[0] + "," + coords[1] + ",\"" + OPENING_HOURS + "\"," + id_user  + ",\"" + IMAGE_PATH + "\")" + footer + "\n")
fout.close()
