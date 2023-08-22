ifneq ($(MAKE_FLAGS),)
	ifneq (,$(findstring CONFIG_DISPLAY_USE_SPI,$(MAKE_FLAGS)))
		EXTRA_SRCDIR+=src/spi
	else
		EXTRA_SRCDIR+=src/i2c
	endif
else
	DEFINES+=CONFIG_DISPLAY_ENABLE_CURSOR_MODE
	DEFINES+=CONFIG_DISPLAY_FIX_FLIP_VERTICALLY
	DEFINES+=CONFIG_DISPLAY_ENABLE_RUN
	EXTRA_SRCDIR+=src/i2c
endif
