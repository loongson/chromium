# Chromium For Loongarch64 （交叉构建）

## 一、Chromium介绍

Chromium是一个开源浏览器项目，旨在为所有用户构建一种更安全、更快、更稳定的网络体验方式。

该项目的网站是：https://www.chromium.org

## 二、Chromium源码获取

### 1. 系统要求

* 至少8GB RAM的64位X86机器，推荐使用超过16GB。
* 至少100GB可用磁盘空间。
* 必须已安装Git和Python v3.8+（必须指向Python v3.8+二进制文件）。如果您系统中没有适当版本，Depot_tools会在$depot_tools/python-bin中绑定适当版本的Python。

大多数交叉构建在Ubuntu上进行，本文以20.04.2 LTS (Focal Fossa) ubuntu版本上进行构建介绍。

### 2. 安装depot_tools工具

Clone `depot_tools`代码仓库：

```shell
$ git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
```

将`depot_tools`添加到您系统环境变量`PATH`的开头（希望可能将其添加到`~/.bashrc`或`~/.zshrc`中）。假设您将`depot_tools`放置到`/path/to/depot_tools`：

```shell
$ export PATH="/path/to/depot_tools:$PATH"
```

当将`depot_tools`克隆到您的`depot_tools`目录时，**千万不要**在`PATH`上使用波浪号`~`，否则`gclient runhooks`将无法运行，您应该使用`$HOME`或绝对路径：

```shell
$ export PATH="${HOME}/depot_tools:$PATH"
```

### 3. 获取源码

创建一个用于存放源码的`chromium`目录（只要整个路径没有空格，你可以随意命名，也可以放在任何你喜欢的地方）：

```shell
$ mkdir ~/chromium && cd ~/chromium
```

运行`fetch`工具（源自于depot_tools）以拉取代码及其依赖项。

```shell
$ fetch --nohooks chromium
```

如果您不需要完整的repo历史记录，可以通过向`fetch`添加`--no-history`参数来节省大量时间。

当`fetch`完成后，它将在工作目录中创建一个`.gclient`隐藏文件和一个名为`src`的目录。**接下来的介绍都假定您已经切换到了`src`目录**：

```shell
$ cd src
```

### 4. 安装其它构建依赖

一旦您完成了代码获取，请运行如下脚本：

```shell
$ ./build/install-build-deps.sh
```

### 5. 运行hooks

一旦你至少运行了一次`install-build-deps`，那么现在你就可以运行Chromium特定的`hooks`，这将下载额外的二进制文件和其他您可能需要的东西：

```shell
$ gclient runhooks
```

### 6. 更新源码

要更新现有的源码，您可以运行以下命令：

```shell
$ git rebase-update
$ gclient sync
```

第一个命令是更新主要的Chromium源代码库，并将您的任何本地分支建立在`main`分支上。如果您不想使用这个脚本，您也可以使用`git pull`或其他常见的Git命令来更新。

第二个命令是将同步依赖项到相应的版本，并根据需要重新运行`hooks`。

要想知道更加详细的`Linux chromium`源码获取，可以参考[Chromium官方文档](https://chromium.googlesource.com/chromium/src/+/main/docs/linux/build_instructions.md)。

## 三、构建配置

`cross-toolchain`目录和`sysroot`目录分别存放着chromium loongarch64交叉构建所需的交叉编译工具链和sysroot。

`chromiumXXX`目录存放着对应版本新旧世界构建适配patch及构建配置说明。

> 目前仅提供chromium98、chromium114和chromium120这三个版本的交叉构建说明。
> 其中chromium98只提供旧世界构建支持，chromium114和chromium120同时提供新旧世界构建支持。

要想继续进行下一步，**必须先完成构建配置**(具体按照相应chromiumXXX中README.md完成)。假如你想构建Chromium120版本，那么必须先完成[Chromium120 构建配置](chromium120/README.md)。如果没有提供您想编译的版本，您可以先用相近的版本进行尝试，如果有问题可以与我们联系（service@loongson.cn）。

> chromium使用[Ninja](https://ninja-build.org)作为主要构建工具，使用称为[GN](https://gn.googlesource.com/gn/+/main/docs/quick_start.md)的工具生成.ninja文件。您可以创建任意数量的具有不同配置的构建目录。
> 
> * 对于每个新的构建目录，您只需要运行一次，Ninja就会根据需要更新构建文件。 
> * 您可以设置任意名称的构建目录，但要确保它是`out`的子目录。
> * 有关其他构建参数，请参见[GN build configuration](https://www.chromium.org/developers/gn-build-configuration)。
> * 有关GN的更多信息，请在命令行上运行`gn help`或阅读[quick start guide](https://gn.googlesource.com/gn/+/main/docs/quick_start.md)。

完成以上配置后，要创建构建目录，请运行：

```shell
$ ./build/cross-build.sh
```

`build/cross-build.sh`是我们额外提供的构建配置脚本，上述适配patch打入后就会包含该脚本。该脚本主要是完成GN构建参数配置及构建目录的设置。

执行完上述脚本后会自动生成`out/la64-cross`（build/cross-build.sh脚本里面默认设置，如果想修改构建目录名称，请修改里面的root_build_dir）构建目录。

## 四、构建 Chromium

使用Ninja构建Chromium（目标为”chrome”）的命令是：

```shell
$ ninja -C out/la64-cross chrome
```

(`ninja` 如果没有，请安装`ninja-build`系统包。)

## 五、运行 Chromium

一旦您完成构建，您可以将`out/la64-cross`目录拷到Loongarch64架构机器上，然后运行浏览器：

```shell
$ out/la64-cross/chrome
```
