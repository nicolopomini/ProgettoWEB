from random import randint
fout = open("shporev","w")
commenti = ["Ottimo negozio", "Ottimi prodotti, poca cortesia","Nella media","Poca assistenza al cliente","Poca gentilezza e disponibilita","Pessimo"]
for i in range(500):
	index = randint(0,4)
	fout.write("('" + commenti[index] + "',null," + str(randint(1,100)) + "," + str(randint(1,200)) + ",now()," + str(index) + "),\n")