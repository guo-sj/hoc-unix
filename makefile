OBJS = init.o math.o symbol.o hoc.tab.o
C_FILES = init.c math.c symbol.c
TARGET = hoc
MID_C_FILE = hoc.tab.c
MID_H_FILE = hoc.tab.h
MID_FILES = $(MID_C_FILE) $(MID_H_FILE)
BISON_FLAGS = -d  # force creation of hoc.tab.h

$(TARGET): $(OBJS)
	cc $(OBJS) -lm -o $(TARGET)

$(OBJS): $(C_FILES) $(MID_C_FILE) $(MID_H_FILE)
	cc -c $(C_FILES) $(MID_C_FILE)

$(MID_FILES): hoc.y
	bison $(BISON_FLAGS) hoc.y

clean:
	rm -rf $(TARGET) $(OBJS) $(MID_FILES) *~ .*~
