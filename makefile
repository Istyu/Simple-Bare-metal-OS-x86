CC=i686-elf-gcc
LD=i686-elf-ld
ASM=nasm
OBJCOPY=i686-elf-objcopy

# Eliminating linker warnings and the correct options
CFLAGS=-ffreestanding -m32 -nostdlib -nostartfiles -nodefaultlibs
LDFLAGS=-T linker.ld -nostdlib --no-warn-rwx-segments

# Target sizes
# 10 sector * 512 byte = 5120 byte
KERNEL_SIZE = 5120

# ---- kernel sources ----
# IMPORTANT: kernel_entry.o must be first!
KERNEL_SRC := $(wildcard kernel/*.c)
KERNEL_OBJ := kernel/kernel_entry.o $(KERNEL_SRC:.c=.o)


# ---- targets ----
all: os.bin

boot.bin:
	$(ASM) -f bin boot/boot.asm -o boot.bin

kernel/kernel_entry.o:
	$(ASM) -f elf32 kernel/kernel_entry.asm -o kernel/kernel_entry.o

kernel/%.o: kernel/%.c
	$(CC) $(CFLAGS) -c $< -o $@

kernel.bin: $(KERNEL_OBJ)
	$(LD) $(LDFLAGS) -o kernel.elf $(KERNEL_OBJ)
	$(OBJCOPY) -O binary kernel.elf kernel.raw
	powershell -Command "$$k=[System.IO.File]::ReadAllBytes('kernel.raw'); $$p=New-Object byte[] ($(KERNEL_SIZE)-$$k.Length); $$t=$$k+$$p; [System.IO.File]::WriteAllBytes('kernel.bin', $$t)"
	del kernel.raw

os.bin: boot.bin kernel.bin
	copy /b boot.bin+kernel.bin os.bin
	@echo DONE! os.bin size: 512 + 5120 = 5632 byte

clean:
	if exist kernel\*.o del /Q kernel\*.o
	if exist *.bin del *.bin
	if exist *.elf del *.elf


#kernel.bin: $(KERNEL_OBJ)
#	$(LD) $(LDFLAGS) -o kernel.elf $(KERNEL_OBJ)
#	$(OBJCOPY) -O binary kernel.elf kernel.raw
#	@# Create an empty 5120-byte file, then copy the kernel onto it.
#	fsutil file createnew kernel.bin $(KERNEL_SIZE)
#	@# This trick overwrites the beginning of kernel.bin with the contents of kernel.raw.
#	powershell -Command "$$k = [System.IO.File]::ReadAllBytes('kernel.raw'); $$b = [System.IO.File]::ReadAllBytes('kernel.bin'); [System.Array]::Copy($$k, $$b, $$k.Length); [System.IO.File]::WriteAllBytes('kernel.bin', $$b)"
#	del kernel.raw