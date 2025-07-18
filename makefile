
export TOOLS_DIR = makefunctions
export SRC_DIR = src
export BUILD_DIR = build
ASM = nasm

.PHONY: all floppy_image kernel bootloader clean always

#
#	Floppy Image
#
floppy_image: ${BUILD_DIR}/main_floppy.img

#create a disk image and truncate
${BUILD_DIR}/main_floppy.img: kernel bootloader
	cp ${BUILD_DIR}/main.bin ${BUILD_DIR}/main_floppy.img
	truncate -s 1440k ${BUILD_DIR}/main_floppy.img

#
#	Bootloader
#
bootloader: ${BUILD_DIR}/bootloader.bin

${BUILD_DIR}/bootloader.bin: always
	${ASM} ${SCR_DIR}/bootloader/boot.asm -f bin -o ${BUILD_DIR}/bootloader.bin

#
#	Kernel
#
kernel: ${BUILD_DIR}/kernel.bin

${BUILD_DIR}/kernel.bin: always
	${ASM} ${SRC_DIR}/kernel/kernel.asm -f bin -o ${BUILD_DIR}/kernel.bin

#
#	Always
#
always:
	mkdir -p ${BUILD_DIR}

#Making clean safer in case build directory is bad
clean:
	${TOOLS_DIR}/safeclean.bash