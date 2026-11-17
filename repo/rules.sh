#!/bin/bash
# Использование: sudo ./rules.sh backend|proxy
set -e

PROXY_IP=192.168.88.29
BACKEND_IP=192.168.88.31
SSH_FROM=192.168.88.0/24   # подсеть

case "$1" in
backend)
nft -f - <<NFT
flush ruleset
table inet filter {
  chain input {
    type filter hook input priority 0; policy drop;
    iif lo accept
    ct state established,related accept
    ip saddr $SSH_FROM tcp dport 22 accept
    ip saddr $PROXY_IP tcp dport 8080 accept
  }
  chain output {
    type filter hook output priority 0; policy drop;
    oif lo accept
    ct state established,related accept
  }
}
NFT
;;
proxy)
nft -f - <<NFT
flush ruleset
table inet filter {
  chain input {
    type filter hook input priority 0; policy drop;
    iif lo accept
    ct state established,related accept
    ip saddr $SSH_FROM tcp dport 22 accept
    tcp dport 5000 accept
  }
  chain output {
    type filter hook output priority 0; policy drop;
    oif lo accept
    ct state established,related accept
    ip daddr $BACKEND_IP tcp dport 8080 accept
  }
}
NFT
;;
*)
echo "Usage: $0 backend|proxy"; exit 1;;
esac
echo "Rules applied for: $1"