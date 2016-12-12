# Name
#
PROG = main

# Utilities
#
PYTHON2 ?= python2
CLOAD_SCRIPT ?= python3 -m cfloader

# Directories
#
BIN = build
LIB = libraries
TOOLS = tools

# Toolchain
#
CROSS_COMPILE = arm-none-eabi-
CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)gcc
OBJCOPY = $(CROSS_COMPILE)objcopy

# Hardware Details
# 
PROCESSOR = -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16
ST_FLAGS = -DUSE_STDPERIPH_DRIVER -DSTM32F4XX -DSTM32F40_41xxx -DHSE_VALUE=8000000
LOAD_ADDRESS = 0x8004000

# Sources and Includes
#
SRCS  = $(wildcard src/*.c)
SRCS += $(wildcard libraries/CMSIS/ST/STM32F4xx/Source/*.c)
SRCS += $(wildcard libraries/STM32F4xx_StdPeriph_Driver/src/*.c)

S_SRCS = $(wildcard src/*.s)

INCLUDES  = -Isrc
INCLUDES += -I$(LIB)/CMSIS/ST/STM32F4xx/Include/
INCLUDES += -I$(LIB)/CMSIS/Include/
INCLUDES += -I$(LIB)/STM32F4xx_StdPeriph_Driver/inc/
# Object Files
#
OBJS = $(SRCS:.c=.o)
OBJS += $(S_SRCS:.s=.o)

# Compiler Flags
#

CFLAGS += -Os -g3 -Werror
CFLAGS += -Wall -Wmissing-braces -fno-strict-aliasing -std=gnu11
CFLAGS += -ffunction-sections -fdata-sections
CFLAGS += -Wdouble-promotion
CFLAGS += -fno-math-errno -DARM_MATH_CM4 -D__FPU_PRESENT=1 -D__TARGET_FPU_VFP
CFLAGS += $(PROCESSOR)
CFLAGS += $(ST_FLAGS)
CFLAGS += $(INCLUDES)

# Linker Flags
#
LFLAGS = --specs=nano.specs $(PROCESSOR) -Wl,-Map=$(PROG).map,--cref,--gc-sections,--undefined=uxTopUsedPriority
LFLAGS += -T $(TOOLS)/stm32f4_flash.ld

# Targets
# 

# Build Targets
all: build

build: $(PROG).hex $(PROG).bin $(PROG).dfu

# Compiles every .c file into .o and places in BIN dir.
compile: $(OBJS)

# dependancies on .o result in compiling a .c 
%.o : %.c 
	$(CC) $(CFLAGS) -c -o $(BIN)/$(notdir $@) $<

# dependancies on .o result in compiling a .s 
%.o : %.s 
	$(CC) -c -o $(BIN)/$(notdir $@) $<

$(PROG).elf : $(OBJS) 
	$(LD) $(LFLAGS) $(foreach o,$(OBJS),$(BIN)/$(notdir $(o))) -lm -o $@

$(PROG).hex : $(PROG).elf
	$(OBJCOPY) $< -O ihex $@

$(PROG).bin : $(PROG).elf
	$(OBJCOPY) $< -O binary --pad-to 0 $@

$(PROG).dfu : $(PROG).bin
	$(PYTHON2) tools/dfu-convert.py -b $(LOAD_ADDRESS):$< $@

# Upload Targets
upload: 
	$(CLOAD_SCRIPT) flash $(PROG).bin stm32-fw
