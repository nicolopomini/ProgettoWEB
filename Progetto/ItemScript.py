import pandas
from random import randint
items = "VH8XKhTRmbEF.csv"
category = ['electronics', 'home', 'books', 'sport', 'other']
ids = 0
lista = pandas.read_csv(items, 
                       names=
                       ["name",
                        "description",
                        "price",
                        "shopID"],
                        sep = "\t").as_matrix()
fout = open("outputItem","w")
n,m = lista.shape
print (n,m)
for i in range(n):
	fout.write("('" + str(lista[i][0]) + "','" + str(lista[i][1]) + "','" + str(category[randint(0,4)]) + "'," + str(lista[i][2]) + "," + str(lista[i][3]) + "),\n")