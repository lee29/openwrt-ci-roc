#!/usr/bin/env bash

set -e
set -o errexit
set -o errtrace

# # 定义错误处理函数
# error_handler() {
#     echo "Error occurred in script at line: ${BASH_LINENO[0]}, command: '${BASH_COMMAND}'"
# }

# # 设置trap捕获ERR信号
# trap 'error_handler' ERR

# source /etc/profile
# BASE_PATH=$(cd $(dirname $0) && pwd)

# REPO_URL=$1
# REPO_BRANCH=$2
# BUILD_DIR=$3
# COMMIT_HASH=$4


add_wifi_default_set() {
    local qualcommax_uci_dir="$OPENWRT_PATH/target/linux/qualcommax/base-files/etc/uci-defaults"
    if [ -d "$qualcommax_uci_dir" ]; then
        install -Dm755 "$GITHUB_WORKSPACE/patches/992_set-wifi-uci.sh" "$qualcommax_uci_dir/992_set-wifi-uci.sh"  
    fi
}

custom_settings() {
    install -Dm755 "$GITHUB_WORKSPACE/patches/991_custom_settings" "$OPENWRT_PATH/package/base-files/files/etc/uci-defaults/991_custom_settings" 
}


fix_compile_vlmcsd() {
    local dir="$OPENWRT_PATH/feeds/packages/net/vlmcsd"
    local patch_src="$GITHUB_WORKSPACE/patches/fix_vlmcsd_with_ccache.patch"
    local patch_dest="$dir/patches"

    if [ -d "$dir" ]; then
        mkdir -p "$patch_dest"
        cp -f "$patch_src" "$patch_dest"
    fi
}

#function others_setting() {
#    local qualcommax_uci_dir="$GITHUB_WORKSPACE/target/linux/qualcommax/base-files/etc/uci-defaults"
#    install -Dm755 "$GITHUB_WORKSPACE/patches/992_set-wifi-uci.sh" "$qualcommax_uci_dir/992_set-wifi-uci.sh"
#    install -Dm755 "$GITHUB_WORKSPACE/patches/991_custom_settings" "$OPENWRT_PATH/package/base-files/files/etc/uci-defaults/991_custom_settings"    
#}




main() {
    add_wifi_default_set
    custom_settings
    fix_compile_vlmcsd
}

main "$@"
