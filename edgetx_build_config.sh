#!/bin/bash

# ============================================
# EdgeTX 固件编译配置文件
# ============================================
# 此配置文件包含EdgeTX固件编译的所有常用配置选项
# 使用方法: ./edgetx_build_config.sh [设备型号]
# ============================================

# EdgeTX源码目录
EDGETX_DIR="/home/deepin/Documents/program/edgetx/edgetx_main"

# 构建输出目录
BUILD_DIR="build-output"

# ============================================
# 设备配置选项
# ============================================

# 可选设备列表（取消注释您需要的设备）
# TX16S: PCB=X10, PCBREV=TX16S
# X10: PCB=X10, PCBREV=EXPRESS
# X12S: PCB=X12S
# X9D+: PCB=X9D+
# T16: PCB=X10, PCBREV=T16
# TX12: PCB=X7, PCBREV=TX12

# 当前编译目标（默认TX16S）
TARGET_PCB="X10"
TARGET_PCBREV="TX16S"

# 如果提供了命令行参数，设置相应的目标
if [ "$1" == "tx16s" ]; then
    TARGET_PCB="X10"
    TARGET_PCBREV="TX16S"
elif [ "$1" == "x10" ]; then
    TARGET_PCB="X10"
    TARGET_PCBREV="EXPRESS"
elif [ "$1" == "x12s" ]; then
    TARGET_PCB="X12S"
    TARGET_PCBREV=""
elif [ "$1" == "x9d+" ]; then
    TARGET_PCB="X9D+"
    TARGET_PCBREV=""
elif [ "$1" == "t16" ]; then
    TARGET_PCB="X10"
    TARGET_PCBREV="T16"
elif [ "$1" == "tx12" ]; then
    TARGET_PCB="X7"
    TARGET_PCBREV="TX12"
fi

# ============================================
# 编译选项配置
# ============================================

# 构建类型 (Release/Debug)
BUILD_TYPE="Release"

# 摇杆模式 (1=右手油门, 2=左手油门, 3=右手油门+俯仰反向, 4=左手油门+俯仰反向)
DEFAULT_MODE=2

# 全局变量支持 (YES/NO)
GVARS="YES"

# PPM单位 (US=微秒, PERCENT_PREC1=百分比精度1)
PPM_UNIT="US"

# Lua混控支持 (YES/NO)
LUA_MIXER="YES"

# 内部GPS (YES/NO) - 仅某些设备支持
INTERNAL_GPS="NO"

# 蓝牙支持 (YES/NO) - 仅某些设备支持
BLUETOOTH="NO"

# 多模块支持 (YES/NO)
MULTIMODULE="YES"

# PXX1协议支持 (YES/NO)
PXX1="YES"

# PXX2协议支持 (YES/NO)
PXX2="YES"

# CRSF协议支持 (YES/NO)
CRSF="YES"

# DSM2协议支持 (YES/NO)
DSM2="YES"

# SBUS协议支持 (YES/NO)
SBUS="YES"

# 调试选项 (YES/NO)
DEBUG="NO"

# 日志功能 (YES/NO)
LOG_TELEMETRY="YES"

# ============================================
# 构建函数
# ============================================

build_firmware() {
    echo "======================================"
    echo "EdgeTX 固件编译配置"
    echo "======================================"
    echo "目标设备: $TARGET_PCB ${TARGET_PCBREV:+($TARGET_PCBREV)}"
    echo "构建类型: $BUILD_TYPE"
    echo "摇杆模式: Mode $DEFAULT_MODE"
    echo "======================================"
    echo ""
    
    # 进入EdgeTX目录
    cd "$EDGETX_DIR" || exit 1
    
    # 创建构建目录
    BUILD_OUTPUT="${BUILD_DIR}-${TARGET_PCB}${TARGET_PCBREV:+-$TARGET_PCBREV}"
    mkdir -p "$BUILD_OUTPUT"
    cd "$BUILD_OUTPUT" || exit 1
    
    echo "正在配置构建系统..."
    
    # 构建CMake命令
    CMAKE_CMD="cmake"
    CMAKE_CMD="$CMAKE_CMD -DPCB=$TARGET_PCB"
    
    if [ -n "$TARGET_PCBREV" ]; then
        CMAKE_CMD="$CMAKE_CMD -DPCBREV=$TARGET_PCBREV"
    fi
    
    CMAKE_CMD="$CMAKE_CMD -DDEFAULT_MODE=$DEFAULT_MODE"
    CMAKE_CMD="$CMAKE_CMD -DGVARS=$GVARS"
    CMAKE_CMD="$CMAKE_CMD -DLUA_MIXER=$LUA_MIXER"
    CMAKE_CMD="$CMAKE_CMD -DCMAKE_BUILD_TYPE=$BUILD_TYPE"
    CMAKE_CMD="$CMAKE_CMD -DCMAKE_TOOLCHAIN_FILE=../cmake/toolchain/arm-none-eabi.cmake"
    CMAKE_CMD="$CMAKE_CMD ../"
    
    echo "执行命令: $CMAKE_CMD"
    eval $CMAKE_CMD
    
    if [ $? -ne 0 ]; then
        echo "错误: CMake配置失败"
        exit 1
    fi
    
    echo ""
    echo "正在编译固件..."
    make -j$(nproc) firmware
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "======================================"
        echo "编译成功！"
        echo "======================================"
        echo "固件文件位置:"
        if [ -f "firmware.bin" ]; then
            echo "  $(pwd)/firmware.bin"
            ls -lh firmware.bin
        fi
        if [ -f "firmware.elf" ]; then
            echo "  $(pwd)/firmware.elf"
            ls -lh firmware.elf
        fi
        echo "======================================"
    else
        echo ""
        echo "======================================"
        echo "编译失败！请检查错误信息"
        echo "======================================"
        exit 1
    fi
}

# ============================================
# 清理函数
# ============================================

clean_build() {
    echo "清理构建目录..."
    cd "$EDGETX_DIR" || exit 1
    rm -rf build-output-*
    echo "清理完成"
}

# ============================================
# 显示帮助信息
# ============================================

show_help() {
    echo "EdgeTX 固件编译配置脚本"
    echo ""
    echo "使用方法:"
    echo "  $0 [选项] [设备型号]"
    echo ""
    echo "设备型号:"
    echo "  tx16s  - RadioMaster TX16S"
    echo "  x10    - FrSky X10"
    echo "  x12s   - FrSky X12S"
    echo "  x9d+   - FrSky X9D+"
    echo "  t16    - Jumper T16"
    echo "  tx12   - RadioMaster TX12"
    echo ""
    echo "选项:"
    echo "  build  - 编译固件 (默认)"
    echo "  clean  - 清理构建目录"
    echo "  help   - 显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  $0 tx16s        # 编译TX16S固件"
    echo "  $0 clean        # 清理构建目录"
    echo ""
}

# ============================================
# 主程序
# ============================================

case "$1" in
    clean)
        clean_build
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        build_firmware
        ;;
esac
