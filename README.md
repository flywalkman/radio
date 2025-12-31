# EdgeTX 固件编译脚本集合

这是一套用于在Linux系统上编译EdgeTX固件的自动化脚本集合。支持多种遥控器型号，提供完整的依赖安装和编译配置。

## 📋 项目简介

EdgeTX是一款开源的遥控器固件，本项目提供了一套完整的编译工具链和自动化脚本，让您能够轻松地在Linux系统上编译自定义的EdgeTX固件。

## 🚀 快速开始

### 1. 环境要求

- 操作系统：Debian/Ubuntu/Deepin Linux
- 磁盘空间：至少5GB可用空间
- 网络：需要访问GitHub和软件源

### 2. 安装编译环境

首先运行环境设置脚本，安装所有必要的依赖：

```bash
chmod +x setup_edgetx_build.sh
./setup_edgetx_build.sh
```

这个脚本会自动安装：
- ARM交叉编译工具链
- CMake构建系统
- Python3及必要的库（PIL, Jinja2, LZ4等）
- Qt开发库（用于Companion和Simulator）
- USB和硬件相关库

### 3. 下载EdgeTX源码

```bash
mkdir -p edgetx
cd edgetx
git clone --recursive -b main https://github.com/EdgeTX/edgetx.git edgetx_main
cd ..
```

### 4. 编译固件

使用配置脚本编译固件（支持多种设备型号）：

```bash
chmod +x edgetx_build_config.sh
./edgetx_build_config.sh tx16s  # 编译RadioMaster TX16S固件
```

## 📚 脚本说明

### setup_edgetx_build.sh

**功能**：完整的编译环境设置脚本

**特点**：
- 自动安装所有必要依赖
- 彩色进度显示
- 错误检测和处理
- 安装后自动验证工具版本

**使用方法**：
```bash
./setup_edgetx_build.sh
```

### edgetx_build_config.sh

**功能**：可配置的固件编译脚本，支持多种设备型号

**支持的设备**：
- `tx16s` - RadioMaster TX16S
- `x10` - FrSky X10
- `x12s` - FrSky X12S
- `x9d+` - FrSky X9D+
- `t16` - Jumper T16
- `tx12` - RadioMaster TX12

**使用方法**：
```bash
# 编译TX16S固件
./edgetx_build_config.sh tx16s

# 编译其他设备固件
./edgetx_build_config.sh x10
./edgetx_build_config.sh x12s

# 清理构建目录
./edgetx_build_config.sh clean

# 显示帮助信息
./edgetx_build_config.sh help
```

**可配置选项**：

脚本内置了丰富的编译选项，您可以编辑脚本修改这些参数：

- `BUILD_TYPE`：构建类型（Release/Debug）
- `DEFAULT_MODE`：摇杆模式（1-4）
- `GVARS`：全局变量支持（YES/NO）
- `LUA_MIXER`：Lua混控支持（YES/NO）
- `PPM_UNIT`：PPM单位（US/PERCENT_PREC1）
- 各种协议支持：PXX1、PXX2、CRSF、DSM2、SBUS等

### build_edgetx.sh

**功能**：简易编译脚本

**使用方法**：
```bash
chmod +x build_edgetx.sh
./build_edgetx.sh
```

## 🔧 高级配置

### 自定义编译选项

编辑 `edgetx_build_config.sh` 文件，在"编译选项配置"部分修改以下参数：

```bash
# 构建类型 (Release/Debug)
BUILD_TYPE="Release"

# 摇杆模式
DEFAULT_MODE=2

# 全局变量支持
GVARS="YES"

# Lua混控支持
LUA_MIXER="YES"

# 协议支持
PXX1="YES"
PXX2="YES"
CRSF="YES"
```

### 编译输出

编译成功后，固件文件位于：
```
edgetx/edgetx_main/build-output-[设备型号]/firmware.bin
```

## 📦 依赖列表

### 基础工具
- build-essential
- git
- cmake
- wget
- curl

### ARM工具链
- gcc-arm-none-eabi
- binutils-arm-none-eabi
- libnewlib-arm-none-eabi
- libstdc++-arm-none-eabi-dev

### Python库
- python3-pil（图像处理）
- python3-jinja2（模板引擎）
- python3-lz4（压缩）
- python3-clang（代码分析）

### Qt开发库
- qtbase5-dev
- qt6-base-dev
- qmake6

### 硬件库
- libusb-1.0-0-dev
- libhidapi-dev
- libudev-dev

## 🛠️ 故障排除

### 常见问题

**Q: 编译失败，提示找不到头文件**
```bash
# 重新运行环境设置脚本
./setup_edgetx_build.sh
```

**Q: Python模块缺失**
```bash
# 检查Python库安装
python3 -c "import PIL, jinja2, lz4, clang"
```

**Q: 权限错误**
```bash
# 确保脚本有执行权限
chmod +x *.sh
```

**Q: 编译过程中内存不足**
```bash
# 减少并行编译任务数
# 编辑脚本，将 make -j$(nproc) 改为 make -j2
```

## 📝 使用示例

### 完整流程示例

```bash
# 1. 克隆本仓库
git clone https://github.com/flywalkman/radio.git
cd radio

# 2. 设置编译环境
chmod +x setup_edgetx_build.sh
./setup_edgetx_build.sh

# 3. 下载EdgeTX源码
mkdir -p edgetx && cd edgetx
git clone --recursive -b main https://github.com/EdgeTX/edgetx.git edgetx_main
cd ..

# 4. 编译固件
chmod +x edgetx_build_config.sh
./edgetx_build_config.sh tx16s

# 5. 查看编译结果
ls -lh edgetx/edgetx_main/build-output-*/firmware.bin
```

## 🔗 相关链接

- [EdgeTX官网](https://edgetx.org/)
- [EdgeTX GitHub](https://github.com/EdgeTX/edgetx)
- [EdgeTX用户手册](https://manual.edgetx.org/)
- [EdgeTX Wiki](https://github.com/EdgeTX/edgetx/wiki)

## 📄 许可证

本项目中的脚本采用MIT许可证。EdgeTX固件遵循其自己的许可证。

## 🤝 贡献

欢迎提交Issue和Pull Request！

## ⚠️ 免责声明

- 本脚本仅用于学习和开发目的
- 刷写固件有风险，请确保备份原始固件
- 使用自编译固件前请充分测试
- 作者不对使用本脚本造成的任何损失负责

## 📧 联系方式

如有问题或建议，请通过GitHub Issues反馈。
