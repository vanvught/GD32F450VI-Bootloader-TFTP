MEMORY
{
  FLASH (rx)      : ORIGIN = 0x08000000, LENGTH = 32K
  TCMSRAM (rw)    : ORIGIN = 0x10000000, LENGTH = 64K
  RAM (xrw)       : ORIGIN = 0x20000000, LENGTH = 192K
  RAMADD (xrw)    : ORIGIN = 0x20030000, LENGTH = 256K
  BKPSRAM (rw)    : ORIGIN = 0x40024000, LENGTH = 4K
}

ENTRY(Reset_Handler)

SECTIONS
{
  __heap_size = DEFINED(__heap_size) ? __heap_size : 4K;
  __stack_size = DEFINED(__stack_size) ? __stack_size : 4K;

  .vectors :
  {
    . = ALIGN(4);
    KEEP(*(.vectors))
    . = ALIGN(4);
    __Vectors_End = .;
    __Vectors_Size = __Vectors_End - __gVectors;
  } >FLASH

  .text :
  {
    . = ALIGN(4);
	*(.text.unlikely*)
	*(.text.hot*)
	*(.text)
	*(.text*)
	*(.glue_7)
	*(.glue_7t)
	*(.eh_frame)
    KEEP (*(.init))
    KEEP (*(.fini))
    . = ALIGN(4);
    _etext = .;
  } >FLASH

  .rodata :
  {
    . = ALIGN(4);
    *(.rodata)
    *(.rodata*)
    . = ALIGN(4);
  } >FLASH
  
  .preinit_array :
  {
    PROVIDE_HIDDEN (__preinit_array_start = .);
    KEEP (*(.preinit_array*))
    PROVIDE_HIDDEN (__preinit_array_end = .);
  } >FLASH
  
  .init_array :
  {
    PROVIDE_HIDDEN (__init_array_start = .);
    KEEP (*(SORT(.init_array.*)))
    KEEP (*(.init_array*))
    PROVIDE_HIDDEN (__init_array_end = .);
  } >FLASH
  
  .fini_array :
  {
    PROVIDE_HIDDEN (__fini_array_start = .);
    KEEP (*(.fini_array*))
    KEEP (*(SORT(.fini_array.*)))
    PROVIDE_HIDDEN (__fini_array_end = .);
  } >FLASH

  .stack :
  {
	. = ALIGN(4);
	PROVIDE( stack_low = . );
    . = . + __stack_size;  
    PROVIDE( _sp = . ); 
    . = ALIGN(4);
  } >TCMSRAM

  .tcmsram :
  {
  	. = ALIGN(4);
    *(.tcmsram)
    *(.tcmsram*)
    . = ALIGN(4);
    _snetwork = .;
    *(.network*)
    . = ALIGN(4);
    _enetwork = .;
  } >TCMSRAM
  
  .heap :
  {
    . = ALIGN(4);
    heap_low = .;
    . = . + __heap_size;
    heap_top = .;
    . = ALIGN(4);
  } >TCMSRAM

  _sidata = LOADADDR(.data);
  .data :
  {
    . = ALIGN(4);
    _sdata = .;
    *(.data)
    *(.data*)
    . = ALIGN(4);
    _edata = .;
  } >RAM AT> FLASH

  . = ALIGN(4);
  .bss :
  {
    _sbss = .;
    __bss_start__ = _sbss;
    *(.bss)
    *(.bss*)
    *(COMMON)
    . = ALIGN(4);
    _ebss = .;
    __bss_end__ = _ebss;
  } >RAMADD

  . = ALIGN(8);
  PROVIDE ( end = _ebss );
  PROVIDE ( _end = _ebss );

  .ramadd :
  {
    _sramadd = .;
  	. = ALIGN(4);
    *(.ramadd)
    *(.ramadd*)
    . = ALIGN(4);
    _eramadd = .;
  } >RAMADD

  .bkpsram :
  {
  	. = ALIGN(4);
    *(.bkpsram)
    *(.bkpsram*)
    *(.configstore*)
  } >BKPSRAM

  /DISCARD/ :
  {
	*(*.ARM.*)
	*(*.comment)
	*(*.debug*)
  }
}

GROUP(libgcc.a)
