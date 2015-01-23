SRCS = $(wildcard *.c)
OBJS = $(SRCS:.c = .o)
CC = gcc

CCFLAGS = -g -Wall -O0

LIBS=-lGL -lGLU

test/luaSOIL.so: $(OBJS)
	$(CC) -shared -fPIC -o $@ $^ $(LIBS)

%.o : %.c
	$(CC) -c $< $(CCFLAGS)

clean:
	rm *.o
