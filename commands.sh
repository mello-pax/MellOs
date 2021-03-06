echo Boot:
nasm "Bootloader/boot.asm" -f bin -o "WeeBins/boot.bin" -i Bootloader
nasm "Kernel/empty_end.asm" -f bin -o "WeeBins/empty_end.bin"

echo Kernel:
i386-elf-gcc -ffreestanding -m32 -g -c "Kernel/kernel.cpp" -o "WeeBins/kernel.o" -I Kernel
nasm "Kernel/kernel_entry.asm" -f elf -o "WeeBins/kernel_entry.o" -i Kernel

echo Drivers + Useful stuff:
i386-elf-gcc -ffreestanding -m32 -g -c "Drivers/port_io.cpp" -o "WeeBins/Drivers/port_io.o" -I Drivers
i386-elf-gcc -ffreestanding -m32 -g -c "Drivers/VGA_Text.cpp" -o "WeeBins/Drivers/VGA_Text.o" -I Drivers
i386-elf-gcc -ffreestanding -m32 -g -c "Drivers/Keyboard.cpp" -o "WeeBins/Drivers/Keyboard.o" -I Drivers

i386-elf-gcc -ffreestanding -m32 -g -c "UsefulStuff/Conversions.cpp" -o "WeeBins/UsefulStuff/Conversions.o" -I UsefulStuff
i386-elf-gcc -ffreestanding -m32 -g -c "UsefulStuff/mem.cpp" -o "WeeBins/UsefulStuff/mem.o"
i386-elf-gcc -ffreestanding -m32 -g -c "UsefulStuff/string.cpp" -o "WeeBins/UsefulStuff/string.o"

echo CPU:
i386-elf-gcc -ffreestanding -m32 -g -c "CPU/idt.cpp" -o "WeeBins/CPU/idt.o"
i386-elf-gcc -ffreestanding -m32 -g -c "CPU/isr.cpp" -o "WeeBins/CPU/isr.o" -I CPU
i386-elf-gcc -ffreestanding -m32 -g -c "CPU/irq.cpp" -o "WeeBins/CPU/irq.o" -I CPU
i386-elf-gcc -ffreestanding -m32 -g -c "CPU/timer.cpp" -o "WeeBins/CPU/timer.o" -I CPU

echo MISC:
i386-elf-gcc -ffreestanding -m32 -g -c "Misc/CmdMode.cpp" -o "WeeBins/Misc/CmdMode.o" -I Misc
i386-elf-gcc -ffreestanding -m32 -g -c "Misc/CodeMode.cpp" -o "WeeBins/Misc/CodeMode.o" -I Misc

echo Linking:
i386-elf-ld -o "WeeBins/kernel.bin" -Ttext 0x1000 "WeeBins/kernel_entry.o" "WeeBins/kernel.o" "WeeBins/Drivers/VGA_Text.o" "WeeBins/Drivers/port_io.o" "WeeBins/UsefulStuff/Conversions.o" "WeeBins/UsefulStuff/mem.o" "WeeBins/CPU/idt.o" "WeeBins/CPU/isr.o" "WeeBins/CPU/irq.o" "WeeBins/CPU/timer.o" "WeeBins/Drivers/Keyboard.o" "WeeBins/Misc/CmdMode.o" "WeeBins/UsefulStuff/string.o" "WeeBins/Misc/CodeMode.o" --oformat binary

cat "WeeBins/boot.bin" "WeeBins/kernel.bin" > "WeeBins/short.bin"
cat "WeeBins/short.bin" "WeeBins/empty_end.bin" > os_image.bin



#qemu-system-x86_64 -s -S -drive format=raw,file=os_image.bin,index=0,if=floppy		# GDB
qemu-system-x86_64 -drive format=raw,file=os_image.bin,index=0,if=floppy			# RUN EMULATOR


