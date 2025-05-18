CC=gcc
CFLAGS=-Wall -std=c99 -g 
ASFLAGS=-g -gstabs

all: genKey cryptTEA decryptTEA

genKey:genKey.c
	$(CC) -Wall -g -o genKey genKey.c

cryptTEA: cryptTEA.c tea.o
	$(CC) $(CFLAGS) -o cryptTEA cryptTEA.c tea.o

decryptTEA: decryptTEA.c tea.o
	$(CC) $(CFLAGS) -o decryptTEA decryptTEA.c tea.o

tea.o:tea.s
	as $(ASFLAGS) -o tea.o tea.s

clean:
	rm -f *.o genKey cryptTEA decryptTEA


