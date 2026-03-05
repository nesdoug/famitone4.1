# makefile to build text2vol4 utility
CC=gcc
LD=
NAME=text2vol4

.PHONY: default clean

default: $(NAME)

$(NAME): $(NAME).cpp
	$(CC) -DUSE_CURSES -o $(NAME) $(NAME).cpp

clean:
	rm $(NAME)

