# Chromium114 构建配置

## 一、目录结构说明

`new-world`代表新世界（ABI2.0）

`old-world`代表旧世界（ABI1.0）

## 二、构建配置说明

### 1. 旧世界构建配置

主要是先获取构建所需的文件：

```
└── sysroot
    ├── debian_bullseye_loong64-sysroot.tar.bz2

├── chromium114
│   ├── old-world
│   │   └── 0001-CH114-old-world-Add-llvm-cross-build-support-for-loo.patch

├── cross-toolchain
│   ├── llvm_install_15.0.7.tar.bz2
```

然后基于已获取chromium源码的`src`目录进行如下操作：

`debian_bullseye_loong64-sysroot.tar.bz2`解压放入`build/linux`目录下：

```shell
$ tar -xjvf debian_bullseye_loong64-sysroot.tar.bz2 -C build/linux/
```

`llvm_install_15.0.7.tar.bz2`解压放入`/opt/llvm_chromium`目录下：

```shell
$ tar -xjvf llvm_install_15.0.7.tar.bz2 -C /opt/llvm_chromium/
```

**注意：** 默认将交叉编译器工具放入/opt/llvm_chromium目录，可以任意指定目录，但若修改需要作如下调整：

> 修改`0001-CH114-old-world-Add-llvm-cross-build-support-for-loo.patch`文件，将里面`/opt/llvm_chromium/llvm_install_15.0.7`全部修改替换成您指定的目录。

`0001-CH114-old-world-Add-llvm-cross-build-support-for-loo.patch`文件打入源码：

```shell
$ patch -Np1 -i 0001-CH114-old-world-Add-llvm-cross-build-support-for-loo.patch
```

**注意：** 如果版本差异导致此处patch打入失败，需要额外修补。有问题可以与我们联系（lbrowser@loongson.cn）

完成上述操作后，我们还需要编译构建自动生成ffmpeg的配置文件，具体操作如下：


```shell
$ cd third_party/ffmpeg
$ ./chromium/scripts/build_ffmpeg.py linux
$ ./chromium/scripts/copy_config.sh
$ ./chromium/scripts/generate_gn.py
$ cd -  （返回至src目录）
```

至此，Chromium114旧世界构建配置已完成，您可以继续完成后面的[交叉构建](../#三构建配置)

### 新世界构建配置

主要是先获取构建所需的文件：

```
└── sysroot
    ├── debian_bullseye_loongarch64-sysroot.tar.bz2

├── cross-toolchain
│   └── Release+Asserts.tar.bz2

├── chromium114
│   ├── new-world
│   │   └── 0001-CH114-new-world-Add-llvm-cross-build-support-for-loo.patch
```

然后基于已获取chromium源码的`src`目录进行如下操作：

`debian_bullseye_loongarch64-sysroot.tar.bz2`解压放入`build/linux`目录下：

```shell
$ tar -xjvf debian_bullseye_loong64-sysroot.tar.bz2 -C build/linux/
```

`Release+Asserts.tar.bz2`替换`third_party/llvm-build/Release+Asserts/`目录：

```shell
$ rm -rf third_party/llvm-build/Release+Asserts
$ tar -xjvf Release+Asserts.tar.bz2 -C third_party/llvm-build/
```

**替换说明：** 这里更新自带llvm，主要是为了支持loongarch64 lld构建（loongarch64 lld从chromium社区自带llvm-18.0.0才正式支持），如果您构建的chromium版本自带的llvm版本超过18.0.0，这里就无需替换（如chromium120就无需替换，直接用社区自带的即可）。

`0001-CH114-new-world-Add-llvm-cross-build-support-for-loo.patch`文件打入源码：

```shell
$ patch -Np1 -i 0001-CH114-new-world-Add-llvm-cross-build-support-for-loo.patch 
```

**注意：** 如果版本差异导致此处patch打入失败，需要额外修补。有问题可以与我们联系（lbrowser@loongson.cn）

完成上述操作后，我们同样还需要编译构建自动生成ffmpeg的配置文件，具体操作如下：

```shell
$ cd third_party/ffmpeg
$ ./chromium/scripts/build_ffmpeg.py linux
$ ./chromium/scripts/copy_config.sh
$ ./chromium/scripts/generate_gn.py
$ cd -  （返回至src目录）
```

至此，Chromium114新世界构建配置已完成，您可以继续完成后面的[交叉构建](../#三构建配置)
