#!/bin/bash
set -x
set +e

export REPO_NAME=$SESSION_NAMESPACE-$(date +%s)
echo $REPO_NAME > repo.txt

mkdir java-web-app
cd java-web-app
echo "# JAVA Web Application" >> README.md
git init
git checkout -b main
git config user.name gitea_admin
git config user.email "gitea_admin@example.com"
git add .
git commit -a -m "Initial Commit"

git remote add origin https://gitea_admin:$GITEA_PASSWORD@gitea.${INGRESS_DOMAIN}/gitea_admin/$REPO_NAME.git
git push -u origin main

mkdir /home/eduk8s/go-web-app-gitops
cd /home/eduk8s/go-web-app-gitops
git clone https://gitea_admin:$GITEA_PASSWORD@gitea.${INGRESS_DOMAIN}/gitea_admin/gitops-source.git .  || rm -rf /home/eduk8s/go-web-app-gitops
kubectl apply -f prep --recursive -n $SESSION_NAMESPACE  || true
rm -rf /home/eduk8s/go-web-app-gitops/prep || true
