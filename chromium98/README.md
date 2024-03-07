在阅读该文件之前，建议您先去阅读[README](../#chromium-for-loongarch64-交叉构建)，以明白您正在做的事情。
# Chromium98 构建配置

## 一、目录结构说明

`old-world`代表旧世界（ABI1.0）

## 二、构建配置说明

### 旧世界构建配置

主要是先获取构建所需的文件：

```
└── sysroot
    └── debian_sid_loong64-sysroot.tar.bz2

├── cross-toolchain
│   ├── llvm_install_15.0.7.tar.bz2

├── chromium98
│   ├── old-world
│   │   └── 0001-CH98-old-world-Add-llvm-cross-build-support-for-loon.patch
```

然后基于已获取chromium源码的`src`目录进行如下操作：

`debian_sid_loong64-sysroot.tar.bz2`解压放入`build/linux`目录下：

```shell
$ tar -xjvf debian_sid_loong64-sysroot.tar.bz2 -C build/linux/
```

`llvm_install_15.0.7.tar.bz2`解压放入`/opt/llvm_chromium`目录下：

```shell
$ tar -xjvf llvm_install_15.0.7.tar.bz2 -C /opt/llvm_chromium/
```

**注意：** 默认将交叉编译器工具放入/opt/llvm_chromium目录，可以任意指定目录，但若修改需要作如下调整：

> 修改`0001-CH98-old-world-Add-llvm-cross-build-support-for-loo.patch`文件，将里面`/opt/llvm_chromium/llvm_install_15.0.7`全部修改替换成您指定的目录。

`0001-CH98-old-world-Add-llvm-cross-build-support-for-loo.patch`文件打入源码：

```shell
$ patch -Np1 -i 0001-CH98-old-world-Add-llvm-cross-build-support-for-loo.patch
```

**注意：** 如果版本差异导致此处patch打入失败，需要额外修补。有问题可以与我们联系（browser@loongson.cn）

完成上述操作后，我们还需要编译构建自动生成ffmpeg的配置文件，具体操作如下：


```shell
$ cd third_party/ffmpeg
$ ./chromium/scripts/build_ffmpeg.py linux --branding=Chrome
$ ./chromium/scripts/copy_config.sh
$ ./chromium/scripts/generate_gn.py
$ cd -  （返回至src目录）
```
**注意：** 请严格按照上述参数运行脚本。
> build__fmpeg.py用于为linux系统下x64/arm64/loong64等平台生成编译配置。  
> copy_config.sh用于将build_ffmpeg.py生成的配置信息更新到chromium/config对应的目录。  
> generate_gn.py用于更新chromium的ffmpeg_generated.gni文件。

至此，Chromium98旧世界构建配置已完成，您可以继续完成后面的[交叉构建](../#三构建配置)
