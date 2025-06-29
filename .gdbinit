define hook-stop
    set disassembly-flavor intel
    layout asm
    layout reg
    set architecture i8086
    b *0x7c00
    target remote localhost:26000
end
