
#Stuff to custom delete, etc
export FILE = RNDM_GARBAGE

export TOOLS = makefunctions
export SRC = src
export BUILD = build

BUILD_REQ = $(BUILD)/bootsector $(BUILD)/kernel
QEMU_FLAGS = -serial stdio

ASM = nasm

IMG_BIN = output
IMG = floppy.img

$(BUILD)/%: $(SRC)/%.asm
	$(ASM) -f bin $< -o $@

$(BUILD)/$(IMG): $(BUILD_REQ)
	rm -f $(BUILD)/$(IMG_BIN)
	cat $(BUILD_REQ) > $(BUILD)/$(IMG_BIN)

	truncate -s 1440k $(BUILD)/$(IMG)
	dd if=$(BUILD)/$(IMG_BIN) of=$(BUILD)/$(IMG) 

run: $(BUILD)/$(IMG)
	qemu-system-x86_64 -drive if=floppy,file=build/$(IMG),format=raw $(QEMU_FLAGS)

#Call like this: make rmb FILE=<filename in build>
rmb:
	rm -f build/$(FILE)

clean:
	rm -rf build/*