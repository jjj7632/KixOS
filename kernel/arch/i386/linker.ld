ENTRY (_start)

SECTIONS
{
    . = 0x00100000;
	/* The kernel will live at 3GB + 1MB in the virtual address space, */
	/* which will be mapped to 1MB in the physical address space. */
	/* Note that we page-align the sections. */

	_kernel_start = .;
        .multiboot.data : {
            *(.multiboot.data)
        }

       .multiboot.text : {
           *(.multiboot.text)
       }

	. += 0xC0000000;
	/* Add a symbol that indicates the start address of the kernel. */
	.text ALIGN (4K) : AT (ADDR (.text) - 0xC0000000)
	{
		 __text_start = .;
		*(.text)
		__text_end = .;
	}
	.rodata ALIGN (4K) : AT (ADDR (.rodata) - 0xC0000000)
	{
		__rodata_start = .;
		*(.rodata)
		 __rodata_end = .;
	}
	.data ALIGN (4K) : AT (ADDR (.data) - 0xC0000000)
	{
		__data_start = .;
		*(.data)
		 __data_end = .;
	}
	.bss ALIGN (4K) : AT (ADDR (.bss) - 0xC0000000)
	{
		__bss_start = .;
		*(COMMON)
		*(.bss)
		*(.bootstrap_stack)
		__bss_end = .;
	}
	/* Add a symbol that indicates the end address of the kernel. */
	_kernel_end = .;
}