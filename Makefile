.PHONY: default
default: protractor;

CC=gcc

protractor.h: protractor.png
	xxd -i protractor.png > protractor.h

protractor: protractor.h protractor.c
	$(CC) -o protractor protractor.c -lraylib

