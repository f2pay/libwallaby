# libkipr
Library for interfacing with KIPR Robot Controllers.

Documentation can be viewed at https://www.kipr.org/doc/index.html or by clicking the "Help" button in the KIPR Software Suite IDE.

# Dependencies

- doxygen
- arm-none-linux-gnueabihf-toolchain-bin (on arch)
- cmake
- make

# CMake Options

Each of the following options may be specified when executing CMake by prefixing the option with `-D` (e.g., `-Dwith_accel=OFF`).

## Modules
  - `with_accel` (default: `ON`) - Build accelerometer support.
  - `with_analog` (default: `ON`) - Build analog sensor support.
  - `with_audio` (default: `ON`) - Build audio support.
  - `with_battery` (default: `ON`) - Build battery support.
  - `with_compass` (default: `ON`) - Build compass support.
  - `with_console` (default: `ON`) - Build console support.
  - `with_digital` (default: `ON`) - Build digital sensor support.
  - `with_gyro` (default: `ON`) - Build gyroscope support.
  - `with_magneto` (default: `ON`) - Build magnetometer support.
  - `with_motor` (default: `ON`) - Build motor support.
  - `with_network` (default: `ON`) - Build network support.
  - `with_servo` (default: `ON`) - Build servo support.
  - `with_thread` (default: `ON`) - Build thread support.
  - `with_time` (default: `ON`) - Build time support.
  - `with_wait_for` (default: `ON`) - Build wait_for support.

## Miscellaneous
  - `with_documentation` (default: `ON`) - Build documentation support (requires `doxygen` installed on system).
  - `with_tests` (default: `ON`) - Build tests.

## Dummy Build
  - `DUMMY` (default: `OFF`) - Build a dummy build for use on computer

# Cross-compiling to aarch64-linux-gnu (e.g., Wombat)

```bash
sudo pacman -S doxygen make cmake
yay -S arm-none-linux-gnueabihf-toolchain-bin

git clone git@github.com:f2pay/libwallaby.git
cd libwallaby
cmake -Bbuild -DCMAKE_TOOLCHAIN_FILE=$(pwd)/toolchain/arm-linux-gnueabihf.cmake .

cd build
make
```

# License

libwallaby is licensed under the terms of the [GPLv3 License](LICENSE).

# Contributing

Want to Contribute? Start Here!:
https://github.com/kipr/KIPR-Development-Toolkit
