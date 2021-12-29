set -x

ytt template -f tls-delegation.yaml -f tap-gui-httpproxy.yaml -f app-accelerator-httpproxy.yaml -f $1 --ignore-unknown-comments | kubectl apply -f -
