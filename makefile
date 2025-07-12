TARGET = hoc
SOURCE = hoc.y
MID_FILE = hoc.c
BISON = bison
CC = gcc

$(TARGET):	$(SOURCE)
	$(BISON) -o $(MID_FILE) $(SOURCE)
	$(CC) $(MID_FILE) -o $(TARGET)

clean:
	rm -rf $(TARGET) $(MID_FILE) *~ .*~
