CC=gcc

protractor: protractor.c
	$(CC) -o protractor protractor.c -lraylib

