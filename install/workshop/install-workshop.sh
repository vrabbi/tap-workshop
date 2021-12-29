set -x

kubectl apply -f accelerator.yaml
ytt template -f ../../resources -f $1 --ignore-unknown-comments | kapp deploy -n tap-install -a tap-workshop -f- --diff-changes --yes
