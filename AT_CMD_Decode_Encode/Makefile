CC = gcc -Wall

ENCODE_OBJS = at_cmd_encode.o at_cmd_table.o
ENCODE_SRC = at_cmd_encode.c at_cmd_table.c

DECODE_OBJS =at_cmd_decode.o at_cmd_table.o
DECODE_SRC = at_cmd_decode.c at_cmd_table.c

encode:$(ENCODE_OBJS)
	$(CC) $(ENCODE_SRC) -o encode

decode:$(DECODE_OBJS)
	$(CC) $(DECODE_SRC) -o encode

%.o:%.c
	$(CC) -c $^ -o $@

.PHONY: clean
clean:
	rm -f *.o
	rm -f .*.sw?