#!/bin/bash

# ============================================
# EdgeTX编译环境设置脚本
# ============================================
# 此脚本会自动安装所有必要的编译依赖
# 适用于Debian/Ubuntu/Deepin系统
# ============================================

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 打印函数
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

echo "============================================"
echo "EdgeTX 编译环境设置脚本"
echo "============================================"
echo ""

# 检查是否为root用户
if [ "$EUID" -eq 0 ]; then
    print_error "请不要使用root用户运行此脚本"
    print_info "使用普通用户运行，脚本会在需要时提示输入sudo密码"
    exit 1
fi

# 检查系统类型
if [ ! -f /etc/os-release ]; then
    print_error "无法确定系统类型"
    exit 1
fi

source /etc/os-release
print_info "检测到系统: $PRETTY_NAME"
echo ""

# ============================================
# 1. 更新系统包列表
# ============================================
print_info "步骤 1/7: 更新系统包列表..."
sudo apt update
echo ""

# ============================================
# 2. 安装基础开发工具
# ============================================
print_info "步骤 2/7: 安装基础开发工具..."
print_info "包含: build-essential, git, cmake, wget, curl"
sudo apt install -y \
    build-essential \
    git \
    cmake \
    wget \
    curl
echo ""

# ============================================
# 3. 安装ARM交叉编译工具链
# ============================================
print_info "步骤 3/7: 安装ARM交叉编译工具链..."
print_info "包含: gcc-arm-none-eabi 及相关库"
sudo apt install -y \
    gcc-arm-none-eabi \
    binutils-arm-none-eabi \
    libnewlib-arm-none-eabi \
    libnewlib-dev \
    libstdc++-arm-none-eabi-dev \
    libstdc++-arm-none-eabi-newlib
echo ""

# ============================================
# 4. 安装USB和硬件相关库
# ============================================
print_info "步骤 4/7: 安装USB和硬件相关库..."
print_info "包含: libusb, libhidapi, libudev"
sudo apt install -y \
    libusb-1.0-0-dev \
    libusb-1.0-doc \
    libhidapi-dev \
    libhidapi-hidraw0 \
    libhidapi-libusb0 \
    libudev-dev
echo ""

# ============================================
# 5. 安装Qt开发库（用于Companion和Simulator）
# ============================================
print_info "步骤 5/7: 安装Qt开发库..."
print_info "包含: Qt5/Qt6 开发工具"
sudo apt install -y \
    qtbase5-dev \
    qt5-qmake \
    libqt5opengl5-dev \
    qt6-base-dev \
    qt6-base-dev-tools \
    qmake6 \
    qt6-qpa-plugins
echo ""

# ============================================
# 6. 安装Python3及必要的Python库
# ============================================
print_info "步骤 6/7: 安装Python3及必要的Python库..."
print_info "包含: python3, pip, PIL, jinja2, lz4, clang"
sudo apt install -y \
    python3 \
    python3-pip \
    python3-dev \
    python3-pil \
    python3-jinja2 \
    python3-lz4 \
    python3-clang \
    python3-clang-17 \
    libclang-17-dev
echo ""

# ============================================
# 7. 安装其他必要工具
# ============================================
print_info "步骤 7/7: 安装其他必要工具..."
print_info "包含: clang, make等"
sudo apt install -y \
    clang \
    make \
    ninja-build
echo ""

# ============================================
# 验证安装
# ============================================
print_info "验证安装的工具版本..."
echo ""
echo "----------------------------------------"
echo "工具链版本信息:"
echo "----------------------------------------"
echo -n "GCC: "
gcc --version | head -n1 || print_warning "GCC未安装"

echo -n "ARM GCC: "
arm-none-eabi-gcc --version | head -n1 || print_warning "ARM GCC未安装"

echo -n "CMake: "
cmake --version | head -n1 || print_warning "CMake未安装"

echo -n "Git: "
git --version || print_warning "Git未安装"

echo -n "Python3: "
python3 --version || print_warning "Python3未安装"

echo -n "Make: "
make --version | head -n1 || print_warning "Make未安装"

echo "----------------------------------------"
echo ""

# ============================================
# 检查Python库
# ============================================
print_info "检查Python库安装情况..."
echo ""

python3 -c "import PIL" 2>/dev/null && echo "✓ PIL (Pillow) 已安装" || print_warning "✗ PIL未安装"
python3 -c "import jinja2" 2>/dev/null && echo "✓ Jinja2 已安装" || print_warning "✗ Jinja2未安装"
python3 -c "import lz4" 2>/dev/null && echo "✓ LZ4 已安装" || print_warning "✗ LZ4未安装"
python3 -c "import clang.cindex" 2>/dev/null && echo "✓ Clang 已安装" || print_warning "✗ Clang未安装"

echo ""
echo "============================================"
print_info "EdgeTX编译环境设置完成！"
echo "============================================"
echo ""
print_info "您现在可以开始编译EdgeTX固件了"
print_info "使用方法: ./edgetx_build_config.sh [设备型号]"
echo ""