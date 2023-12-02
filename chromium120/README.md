# Chromium120 构建配置

## 目录结构说明

`new-world`代表新世界（ABI2.0）

`old-world`代表旧世界（ABI1.0）

## 构建配置说明

### 旧世界构建配置

主要是先获取构建所需的文件：

```
└── sysroot
    ├── debian_bullseye_loong64-sysroot.tar.bz2

├── cross-toolchain
│   ├── llvm_install_15.0.7.tar.bz2

├── chromium120
│   ├── old-world
│   │   └── 0001-CH120-old-world-Add-llvm-cross-build-support-for-loo.patch
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

> 修改`0001-CH120-old-world-Add-llvm-cross-build-support-for-loo.patch`文件，将里面`/opt/llvm_chromium/llvm_install_15.0.7`全部修改成替换您指定的目录。

`0001-CH120-old-world-Add-llvm-cross-build-support-for-loo.patch`文件打入源码：

```shell
$ patch -Np1 -i 0001-CH120-old-world-Add-llvm-cross-build-support-for-loo.patch 
```

完成上述操作后，我们还需要编译构建自动生成ffmpeg的配置文件，具体操作如下：

```shell
$ cd third_party/ffmpeg
$ ./chromium/scripts/build_ffmpeg.py linux
$ ./chromium/scripts/copy_config.sh
$ ./chromium/scripts/generate_gn.py
$ cd -  （返回至src目录）
```

至此，Chromium120旧世界构建配置已完成，您可以继续完成后面的[交叉构建](../#三构建配置)

### 新世界构建配置

主要是先获取构建所需的文件：

```
└── sysroot
    ├── debian_bullseye_loongarch64-sysroot.tar.bz2

├── chromium120
│   ├── new-world
│   │   └── 0001-CH120-new-world-Add-llvm-cross-build-support-for-loo.patch
```

然后基于已获取chromium源码的`src`目录进行如下操作：

`debian_bullseye_loongarch64-sysroot.tar.bz2`解压放入`build/linux`目录下：

```shell
$ tar -xjvf debian_bullseye_loong64-sysroot.tar.bz2 -C build/linux/
```

`0001-CH120-new-world-Add-llvm-cross-build-support-for-loo.patch`文件打入源码：

```shell
$ patch -Np1 -i 0001-CH120-new-world-Add-llvm-cross-build-support-for-loo.patch 
```

新世界无需提供编译器，直接使用chromium自带的`third_party/llvm-build/Release+Asserts/`即可，无需额外配置。
完成上述操作后，我们同样还需要编译构建自动生成ffmpeg的配置文件，具体操作如下：

```shell
$ cd third_party/ffmpeg
$ ./chromium/scripts/build_ffmpeg.py linux
$ ./chromium/scripts/copy_config.sh
$ ./chromium/scripts/generate_gn.py
$ cd -  （返回至src目录）
```

至此，Chromium120新世界构建配置已完成，您可以继续完成后面的[交叉构建](../#三构建配置)
