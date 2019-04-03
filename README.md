# Linux From scratch build scripts

This repository contains my build system to cross-compile and build a complete embedded Linux system from sources.
I use it for differents projects and targets : Router, Firewall, Set-top box, "Proof of concept" with differents evaluation boards...
Various targets are currently supported : ARM, PowerPC, x86, FPGA SOC...

## Requirement

A Linux machine with the "build-essential" package installed.

## Usage

To setup the build environnement run from the repository root folder

```c
./set_env.sh [TARGET_NAME]
```

To see the available targets just run :

```c
./set_env.sh
```

Once done you can build the target with this command :

```c
sysbuild.sh
```

This will build the cross-compiler, glibc, kernel and all the target root file system...
The whole process can take from 15 minutes to some hours depending of your setup.

Once done you can find the root-fs in the folder "targets/TARGET_NAME/root-fs".

To deploy the root-fs to a flash media/disk you can use the init_sd.sh script :

```c
init_sd.sh [DEVICE_PATH]
```

example :

```c
init_sd.sh /dev/mmcblk0p2
```

The partition is then formatted and all files copied to the media.
Please note that all binaries are stripped during the copy to the media.
If you want to keep the debug informations, use the NOSTRIP argument:

```c
init_sd.sh /dev/mmcblk0p2 NOSTRIP
```

To clean up a target :

```c
clean.sh
```

## Folders description

/scripts : Contains the common build scripts.

/targets : Contains all targets

/targets/common/config : Contains the common/default configuration files.

/targets/[TARGET_NAME] : Target home directory.

/targets/[TARGET_NAME]/config : Target configuration.

/targets/[TARGET_NAME]/download (1) : Downloaded source archives.

/targets/[TARGET_NAME]/cross-tools (2) : Cross-compiler binaries.

/targets/[TARGET_NAME]/build (2) : Build folder.

/targets/[TARGET_NAME]/sources (2) : Unpacked sources.

/targets/[TARGET_NAME]/root-fs (2) : target root-fs.

/targets/[TARGET_NAME]/fs_mirror (2) : target root-fs stripped folder generated during the deployment (init_sd.sh).

/targets/[TARGET_NAME]/mount_point (2) : target flash media/disk mount point used during the deployment (init_sd.sh).

(1) Folders created during the build.

(2) Folders created during the build and deleted by the "clean.sh" command.

### Some targets examples successfully tested

- Altera/Intel Cyclone V DE10-Nano board.

- Atmel Sama5D2 Xplained.

- Raspberry PI 1/2/3/Zero (W).

- Banana Pi R2.

- BeagleBone Black.

- NVidia Jetson TX2.

- NXP P2020 Reference Design Board (PowerPC P2020).

- OCEDO G50w (PowerPC P1020).

- PC 486, PC 686, PC104 boards... (x86/x64)

- Solid-run ClearFog.

(c) 2004-2019 Jean-François DEL NERO
