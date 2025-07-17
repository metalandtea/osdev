
SRC_DIR = src
BUILD_DIR = build
ASM = nasm

#create a disk image and truncate
${BUILD_DIR}/main_floppy.img: ${BUILD_DIR}/main.bin
	cp ${BUILD_DIR}/main.bin ${BUILD_DIR}/main_floppy.img
	truncate -s 1440k ${BUILD_DIR}/main_floppy.img

#Build the main binary file
${BUILD_DIR}/main.bin: ${SRC_DIR}/main.asm
	${ASM} ${SRC_DIR}/main.asm -f bin -o ${BUILD_DIR}/main.bin

clean:
	rm -f ${BUILD_DIR}/main.bin ${BUILD_DIR}/main_floppy.img