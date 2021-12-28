## Install the E2E Workshop

Create a public project called **tanzu-e2e** in your Harbor instance. There is a Dockerfile in the root directory of this repo. From that root directory, build a Docker image and push it to the project you created:
** COPY THE tanzu-vscode-extension.vsix file you have download to the root directory where the docker file is located **
```
docker build . -t harbor.(your-ingress-domain)/tanzu-e2e/eduk8s-tap-workshop
docker push harbor.(your-ingress-domain)/tanzu-e2e/eduk8s-tap-workshop
```

From this directory of the repo, execute the script to install the Metacontrollers. They will manage resources specific to workshop sessions, such as Harbor projects:
```
./install-metacontrollers.sh /path/to/my/values.yaml
```

Then, install the Learning Center workshop:
```
./install-workshop.sh /path/to/my/values.yaml
```
