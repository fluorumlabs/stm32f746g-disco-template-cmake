SET(CMAKE_SYSTEM_NAME Generic)
SET(CMAKE_SYSTEM_VERSION 1)

SET(TOOLCHAIN_DIR ${CMAKE_SOURCE_DIR}/Toolchain/bin)
# workaround for OSX
set(CMAKE_OSX_DEPLOYMENT_TARGET "")

# specify the cross compiler
SET(CMAKE_C_COMPILER ${TOOLCHAIN_DIR}/arm-none-eabi-gcc)
SET(CMAKE_CXX_COMPILER ${TOOLCHAIN_DIR}/arm-none-eabi-c++)
SET(ENV{PATH} ${CMAKE_SOURCE_DIR}/Toolchain/bin)
SET(CMAKE_AR "${TOOLCHAIN_DIR}/arm-none-eabi-ar" CACHE PATH "" FORCE)
SET(CMAKE_RANLIB "${TOOLCHAIN_DIR}/arm-none-eabi-ranlib" CACHE PATH "" FORCE)
SET(CMAKE_LINKER "${TOOLCHAIN_DIR}/arm-none-eabi-ld" CACHE PATH "" FORCE)
SET(CMAKE_SIZE "${TOOLCHAIN_DIR}/arm-none-eabi-size")
SET(CMAKE_OBJCOPY "${TOOLCHAIN_DIR}/arm-none-eabi-objcopy")
SET(CMAKE_OBJDUMP "${TOOLCHAIN_DIR}/arm-none-eabi-objdump")

set(CMAKE_C_LINK_FLAGS "")

SET(LINKER_SCRIPT ${CMAKE_SOURCE_DIR}/STM32F746NGHx_FLASH.ld)
SET(COMMON_FLAGS "-mcpu=cortex-m4 -mthumb -ffunction-sections -fstrict-aliasing -fno-exceptions -fomit-frame-pointer -fdata-sections -Wall")
#SET(COMMON_FLAGS "-mcpu=cortex-m4 -mthumb -mthumb-interwork -mfloat-abi=hard -mfpu=fpv4-sp-d16 -ffunction-sections -fdata-sections -g -fno-common -fmessage-length=0")
SET(CMAKE_CXX_FLAGS "${COMMON_FLAGS} -std=c++11 -fshort-wchar")
SET(CMAKE_C_FLAGS "${COMMON_FLAGS} -std=gnu99 -fshort-wchar")
SET(CMAKE_EXE_LINKER_FLAGS "-Wl,-gc-sections -T${LINKER_SCRIPT}")

# Search for programs only in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# Search for libraries and headers only in the target directories
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
