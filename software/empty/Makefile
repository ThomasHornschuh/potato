# The Potato Processor Software Components
# (c) Kristian Klomsten Skordal 2015 <kristian.skordal@wafflemail.net>
# Report bugs and issues on <https://github.com/skordal/potato/issues>

.PHONY: all clean

TARGET_PREFIX ?= riscv32-unknown-elf
TARGET_CC := $(TARGET_PREFIX)-gcc
TARGET_LD := $(TARGET_PREFIX)-gcc
TARGET_SIZE := $(TARGET_PREFIX)-size
TARGET_OBJCOPY := $(TARGET_PREFIX)-objcopy
HEXDUMP ?= hexdump

TARGET_CFLAGS += -m32 -march=RV32I -g -Wall -Os -fomit-frame-pointer \
          -msoft-float \
	 -I../.. -I../../libsoc -std=gnu99 \
	-Wall -Werror=implicit-function-declaration 
       
TARGET_LDFLAGS += -m32 -march=RV32I -L../libsoc \
	-Wl,-m,elf32lriscv -nostartfiles  --specs=nosys.specs -Wl,-T../potato.ld \
	-Wl,--gc-sections -lgcc

       
OBJECTS := empty.o start.o

all: empty.coe

empty.elf: $(OBJECTS)
	$(TARGET_LD) -o empty.elf $(TARGET_LDFLAGS) $(OBJECTS)
	$(TARGET_SIZE) empty.elf

empty.bin: empty.elf
	$(TARGET_OBJCOPY) -j .text -j .data -O binary empty.elf empty.bin

empty.coe: empty.bin
	echo "memory_initialization_radix=16;" > empty.coe
	echo "memory_initialization_vector=" >> empty.coe
	for i in $$(seq 0 63); do echo 00000013 >> empty.coe; done
	$(HEXDUMP) -v -e '1/4 "%08x\n"' empty.bin >> empty.coe
	echo ";" >> empty.coe

clean:
	-$(RM) $(OBJECTS)
	-$(RM) empty.elf empty.bin empty.coe

# Object file rules:

empty.o: empty.c ../../potato.h
	$(TARGET_CC) -c -o $@ $(TARGET_CFLAGS) $<

start.o: ../start.S
	$(TARGET_CC) -c -o $@ $(TARGET_CFLAGS) $<

