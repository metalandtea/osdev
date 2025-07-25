
export TOOLS = makefunctions
export SRC = src
export BUILD = build

export SRC_BT = $(SRC)/bootloader

ASM = nasm

#LINK = ld
#CC = gcc
#CC_FL = -mx32 -nostdinc -ffreestanding

$(BUILD)/bootsector: $(SRC_BT)/bootsector.asm
	$(ASM) -f bin $(SRC_BT)/bootsector.asm -o $(BUILD)/bootsector

$(BUILD)/kernel: $(SRC_BT)/kernel.asm
	$(ASM) -f bin $(SRC_BT)/kernel.asm -o $(BUILD)/kernel

$(BUILD)/floppy.img: $(BUILD)/bootsector $(BUILD)/kernel
#	add bootsector and kernel together
	cat $(BUILD)/bootsector $(BUILD)/kernel > $(BUILD)/outputbin

#	make floppy
	truncate -s 1440k $(BUILD)/floppy.img

	dd if=$(BUILD)/outputbin of=$(BUILD)/floppy.img
	

clean:
	rm -rf $(BUILD)/*