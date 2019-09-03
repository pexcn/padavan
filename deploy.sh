#!/bin/bash -e

prepare() {
  local api_url="https://api.github.com/repos/tcnksm/ghr/releases/latest"
  local download_tag=$(curl -sSL $api_url | grep "tag_name" | sed -E 's/.*"([^"]+)".*/\1/')
  local download_url=$(curl -sSL $api_url | grep "browser_download_url" | grep "linux" | grep "amd64" | cut -d '"' -f 4)

  curl -sSL $download_url | sudo -E tar -zxf - -C /usr/local/bin/ ghr_${download_tag}_linux_amd64/ghr --strip-components 1
}

release() {
  cp -r trunk/images release
}

deploy() {
  local user=$(echo $TRAVIS_REPO_SLUG | cut -d "/" -f 1)
  local repo=$(echo $TRAVIS_REPO_SLUG | cut -d "/" -f 2)
  local version=$(date +%Y%m%d)

  ghr -t $GITHUB_TOKEN \
    -u $user \
    -r $repo \
    -c $TRAVIS_COMMIT \
    -n $version \
    -delete \
    $version release
}

prepare
release
deploy
