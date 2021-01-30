#!/bin/bash -e

CONFIG_NAME="$1"

select_config() {
  rm -f trunk/.config
  cp trunk/configs/templates/$CONFIG_NAME.config trunk/.config
}

update_config() {
  local line=$(cat trunk/.config | grep -m 1 "CONFIG_TOOLCHAIN_DIR=")
  local replace="CONFIG_TOOLCHAIN_DIR=$(pwd)/toolchain-mipsel"
  sed -i "s#$line#$replace#g" trunk/.config
}

build_toolchain() {
  cd toolchain-mipsel
  [ -e .toolchain-existed ] && return
  sudo ./clean_sources
  sudo ./build_toolchain
  touch .toolchain-existed
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
