#!/bin/bash -e

select_config() {
  cp trunk/configs/templates/mi_mini.config trunk/.config
}

update_config() {
  local line=$(cat trunk/.config | grep -m 1 "CONFIG_TOOLCHAIN_DIR=")
  local replace="CONFIG_TOOLCHAIN_DIR=$(pwd)/toolchain-mipsel"
  sed -i "s#$line#$replace#g" trunk/.config
}

build_toolchain() {
  cd toolchain-mipsel
  sudo ./clean_sources
  sudo ./build_toolchain
  cd ..
}

build_firmware() {
  cd trunk
  sudo ./clear_tree
  sudo ./build_firmware
  cd ..
}

select_config
update_config
build_toolchain
build_firmware
