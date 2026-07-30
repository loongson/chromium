在阅读该文件之前，建议您先去阅读[README](../#chromium-for-loongarch64-交叉构建)，以明白您正在做的事情。
# Chromium150 构建配置

## 构建配置说明

### 旧世界构建配置

主要是先获取构建所需的文件：

* `sysroot (debian_bullseye_loong64-sysroot.tar.bz2): `  点击[下载](https://ftp.loongnix.cn/browser/build/sysroot/debian_bullseye_loong64-sysroot.tar.bz2)
* `llvm (llvm-toolchain_20.1.8-1_amd64-linux-gnu_debian-10.tar.gz): `  点击[下载](https://ftp.loongnix.cn/toolchain/llvm/llvm20/llvm-toolchain_20.1.8-1_amd64-linux-gnu_debian-10.tar.gz)
* `rust-toolchain (rust-1.92.0-nightly-cross.tar.bz2): `  点击[下载](https://ftp.loongnix.cn/browser/build/toolchain/rust-1.92.0-nightly-cross.tar.bz2)


然后基于已获取chromium源码的`src`目录进行如下操作：

`debian_bullseye_loong64-sysroot.tar.bz2`解压放入`build/linux`目录下：

```shell
$ tar -xjvf debian_bullseye_loong64-sysroot.tar.bz2 -C build/linux/
```

`llvm-toolchain_20.1.8-1_amd64-linux-gnu_debian-10.tar.gz`解压放入`/opt/`目录下：

```shell
$ tar -xjvf llvm-toolchain_20.1.8-1_amd64-linux-gnu_debian-10.tar.gz -C /opt/
```

`rust-1.92.0-nightly-cross.tar.bz2`解压放入`/opt/`目录下：

```shell
$ tar -xjvf rust-1.92.0-nightly-cross.tar.bz2 -C /opt/
```

**注意：** 默认将交叉编译器工具链放入/opt/目录，可以任意指定目录，但若修改需要作如下相应调整：

> * llvm: 需要调整build/config/clang/clang.gni文件中`default_clang_base_path`变量
> * rust-toolchain: 需要调整build/cross-build.sh脚本中`rust_bindgen_root`和`rust_sysroot_absolute`参数

### 新世界构建配置

主要是先获取构建所需的文件：

* `sysroot (debian_bullseye_loongarch64-sysroot.tar.bz2): `  点击[下载](http://ftp.loongnix.cn/browser/build/sysroot/debian_bullseye_loongarch64-sysroot.tar.bz2)
* `llvm (Release+Asserts-150.tar.bz2): `  点击[下载](http://ftp.loongnix.cn/browser/build/toolchain/Release+Asserts-150.tar.bz2)


然后基于已获取chromium源码的`src`目录进行如下操作：

`debian_bullseye_loongarch64-sysroot.tar.bz2`解压放入`build/linux`目录下：

```shell
$ tar -xjvf debian_bullseye_loong64-sysroot.tar.bz2 -C build/linux/
```

`Release+Asserts-150.tar.bz2`替换`third_party/llvm-build/Release+Asserts`目录：

```shell
$ rm -rf third_party/llvm-build/Release+Asserts
$ tar -xjvf Release+Asserts-150.tar.bz2 -C third_party/llvm-build/
```

## 打入适配patch

* `适配patch (0001-la64-cross-CH150-Add-loongarch-build-support-for-old-new-w.patch): `  点击[下载](./0001-la64-cross-CH150-Add-loongarch-build-support-for-old-new-w.patch)

`0001-la64-cross-CH150-Add-loongarch-build-support-for-old-new-w.patch`文件打入源码：

```shell
$ patch -Np1 -i 0001-la64-cross-CH150-Add-loongarch-build-support-for-old-new-w.patch
```

**注意：** 如果版本差异导致此处patch打入失败，需要额外修补。有问题可以与我们联系（browser@loongson.cn）

**ffmpeg配置**

上述patch基于150.0.7871.211构建生成，已包含ffmpeg配置文件的生成，patch打入成功则忽略下面的ffmpeg配置。
如果patch打入后，ffmpeg配置文件有冲突，还需进行如下操作：

```shell
$ cd third_party/ffmpeg
$ ../../media/ffmpeg/scripts/build_ffmpeg.py linux --branding=Chrome
$ ./chromium/scripts/copy_config.sh
$ ../../media/ffmpeg/scripts/generate_gn.py
$ cd -  （返回至src目录）
```
**注意：** 请严格按照上述参数运行脚本。
> build__fmpeg.py用于为linux系统下x64/arm64/loong64等平台生成编译配置。  
> copy_config.sh用于将build_ffmpeg.py生成的配置信息更新到chromium/config对应的目录。      
> generate_gn.py用于更新chromium的ffmpeg_generated.gni文件。


至此，Chromium150构建配置已完成，您可以继续完成后面的[交叉构建](../#三构建配置)
