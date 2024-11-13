# 修改默认IP
sed -i 's/192.168.1.1/10.10.10.254/g' package/base-files/files/bin/config_generate

# 修改亚瑟LED为绿色
# sed -i 's/&status_blue/\&status_green/g' target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6000-re-ss-01.dts

# 移除要替换的包
rm -rf feeds/packages/net/adguardhome

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# Alist & AdGuardHome & 集客无线AC控制器 & Lucky & AriaNg
git_sparse_clone main https://github.com/kenzok8/small-package adguardhome luci-app-adguardhome ddns-go luci-app-ddns-go
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/passwall
git clone --depth=1 https://github.com/morytyann/OpenWrt-mihomo package/mihomo

./scripts/feeds update -a
./scripts/feeds install -a
