# The Potato Processor Software Components
# (c) Kristian Klomsten Skordal 2015 <kristian.skordal@wafflemail.net>
# Report bugs and issues on <https://github.com/skordal/potato/issues>

.PHONY: all clean

TARGET_PREFIX ?= riscv64-unknown-elf
TARGET_CC := $(TARGET_PREFIX)-gcc
TARGET_LD := $(TARGET_PREFIX)-gcc
TARGET_SIZE := $(TARGET_PREFIX)-size
TARGET_OBJCOPY := $(TARGET_PREFIX)-objcopy
HEXDUMP ?= hexdump

TARGET_CFLAGS += -m32 -march=RV32I -Wall -Os -fomit-frame-pointer \
	-ffreestanding -fno-builtin -I../.. -I../../libsoc -std=gnu99 \
	-Wall -Werror=implicit-function-declaration
TARGET_LDFLAGS += -m32 -march=RV32I -nostartfiles -L../libsoc \
	-Wl,-m,elf32lriscv --specs=nosys.specs -Wl,-T../potato.ld \
	-Wl,--gc-sections

OBJECTS := main.o sha256.o start.o

all: sha256.coe

sha256.elf: $(OBJECTS)
	$(TARGET_LD) -o sha256.elf $(TARGET_LDFLAGS) $(OBJECTS)
	$(TARGET_SIZE) sha256.elf

sha256.bin: sha256.elf
	$(TARGET_OBJCOPY) -j .text -j .data -O binary sha256.elf sha256.bin

sha256.coe: sha256.bin
	echo "memory_initialization_radix=16;" > sha256.coe
	echo "memory_initialization_vector=" >> sha256.coe
	for i in $$(seq 0 63); do echo 00000013 >> sha256.coe; done
	$(HEXDUMP) -v -e '1/4 "%08x\n"' sha256.bin >> sha256.coe
	echo ";" >> sha256.coe

clean:
	-$(RM) $(OBJECTS)
	-$(RM) sha256.elf sha256.bin sha256.coe

# Object file rules:

main.o: main.c sha256.h ../../platform.h ../../potato.h
	$(TARGET_CC) -c -o $@ $(TARGET_CFLAGS) $<

sha256.o: sha256.c sha256.h
	$(TARGET_CC) -c -o $@ $(TARGET_CFLAGS) $<

start.o: ../start.S ../../platform.h
	$(TARGET_CC) -c -o $@ $(TARGET_CFLAGS) $<

