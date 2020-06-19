#!/bin/bash

echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
mkdir package/lean
cp -r ../lede/package/lean/{shadowsocksr-libev,pdnsd-alt,microsocks,dns2socks,simple-obfs,tcpping,v2ray-plugin,v2ray,trojan,ipt2socks,redsocks2} package/lean
./scripts/feeds update -a && ./scripts/feeds install -a
