cmake_minimum_required(VERSION 3.5)
project(stm32f746g-disco-template-cmake)

set(EXECUTABLE_OUTPUT_PATH "${PROJECT_SOURCE_DIR}/Build")

set(CMAKE_TOOLCHAIN_FILE STM32F7XX.cmake)
include(${CMAKE_TOOLCHAIN_FILE})

set(MCU STM32F746xx)

add_definitions(-D${MCU})

file(GLOB_RECURSE APPLICATION_SOURCES "Application/*.c")
file(GLOB_RECURSE MX_SOURCES_MAIN "Src/main.c")
file(GLOB_RECURSE MX_SOURCES_IT "Src/stm32f7xx_it.c")
file(GLOB_RECURSE MX_SOURCES_HAL_MSP "Src/stm32f7xx_hal_msp.c")
file(GLOB_RECURSE HAL_SOURCES "Drivers/STM32F7xx_HAL_Driver/Src/*.c")
file(GLOB_RECURSE BSP_SOURCES "Drivers/BSP/STM32746G-Discovery/*.c")
file(GLOB_RECURSE BSP_COPONENTS_SOURCES "Drivers/BSP/Components/*.c")
file(GLOB_RECURSE UTIL_LOG_SOURCES "Utilities/Log/*.c")
file(GLOB_RECURSE SYSCALLS "startup/syscalls.c")
file(GLOB_RECURSE CMSIS "Src/system_stm32f7xx.c")
file(GLOB_RECURSE STARTUP "startup/startup_stm32f746xx.s")

set_property(SOURCE startup/startup_stm32f746xx.s PROPERTY LANGUAGE C)

include_directories(Inc)
include_directories(Application)
include_directories(Drivers/STM32F7xx_HAL_Driver/Inc)
include_directories(Drivers/CMSIS/Include)
include_directories(Drivers/CMSIS/Device/ST/STM32F7xx/Include)
include_directories(Drivers/BSP/STM32746G-Discovery)
include_directories(Drivers/BSP/Components)
include_directories(Utilities/Log)

add_executable(${PROJECT_NAME}.elf ${APPLICATION_SOURCES} ${MX_SOURCES_MAIN} ${MX_SOURCES_IT} ${MX_SOURCES_HAL_MSP} ${HAL_SOURCES} ${BSP_SOURCES} ${UTIL_LOG_SOURCES} ${LINKER_SCRIPT} ${SYSCALLS} ${STARTUP} ${CMSIS})

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--cref,--no-wchar-size-warning,--gc-sections,-Map=${PROJECT_SOURCE_DIR}/Build/${PROJECT_NAME}.map --specs=nano.specs")
set(HEX_FILE ${PROJECT_SOURCE_DIR}/Build/${PROJECT_NAME}.hex)
set(BIN_FILE ${PROJECT_SOURCE_DIR}/Build/${PROJECT_NAME}.bin)
set(ASM_FILE ${PROJECT_SOURCE_DIR}/Build/${PROJECT_NAME}.asm)
add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -S -O ihex --gap-fill=0 $<TARGET_FILE:${PROJECT_NAME}.elf> ${HEX_FILE}
        COMMAND ${CMAKE_OBJCOPY} -S -O binary --gap-fill=0 $<TARGET_FILE:${PROJECT_NAME}.elf> ${BIN_FILE}
        COMMAND ${CMAKE_OBJDUMP} --prefix-addresses -S -D $<TARGET_FILE:${PROJECT_NAME}.elf> | sed 's/^080/\\/\\/ 080/'>${ASM_FILE}
        COMMENT "[100%] Building ${HEX_FILE} \n[100%] Building ${BIN_FILE}")

# Use CLANG for static analysis
set(CLANG "clang")

set(ANALYZER_FLAGS -Xanalyzer -analyzer-checker=alpha,core,deadcode,nullability,optin,security -Xanalyzer -analyzer-disable-checker=alpha.core.FixedAddr -Xanalyzer -analyzer-opt-analyze-nested-blocks -Xanalyzer -analyzer-output=text)

get_property(ALL_INCLUDE_DIRECTORIES DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY INCLUDE_DIRECTORIES)
set(INCLUDE_FLAGS)
foreach (INCLUDE_DIRECTORY ${ALL_INCLUDE_DIRECTORIES})
    list(APPEND INCLUDE_FLAGS "-I${INCLUDE_DIRECTORY}")
endforeach ()

foreach (SOURCE_FILE ${MX_SOURCES_MAIN} ${MX_SOURCES_IT} ${MX_SOURCES_HAL_MSP} ${APPLICATION_SOURCES})
    add_custom_command(TARGET ${PROJECT_NAME}.elf
            PRE_LINK
            COMMAND ${CLANG} -I${PROJECT_SOURCE_DIR}/Toolchain/arm-none-eabi/include -Weverything -Reverything --analyze ${ANALYZER_FLAGS} ${INCLUDE_FLAGS} -std=gnu99 -D${MCU}
            ${SOURCE_FILE})
endforeach ()
