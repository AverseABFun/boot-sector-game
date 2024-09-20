all: clean text disk.img emulate

debug: clean text preprocess disk.img emulate-debug

.PHONY: clean text preprocess emulate emulate-debug

clean: 
	rm -f disk.bin
	rm -f disk.img

src/generated/text.s: data/text.json
	node data/compile.mjs

text: src/generated/text.s

disk.bin: src/boot.s
	nasm src/boot.s -f bin -o disk.bin

disk.img: disk.bin
	dd if=disk.bin of=disk.img bs=512

preprocess: src/boot.s
	nasm -e src/boot.s -o src/generated/preprocessed.s

emulate:
	bochs -f bochsrc.txt -q -rc auto-continue.txt

emulate-debug:
	bochs -f bochsrc.txt -q
