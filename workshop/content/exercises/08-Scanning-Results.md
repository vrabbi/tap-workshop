So our image was built and passed our compliance policy for vulnerability checks, but now we want to see what vulnerabilities do exist in our image and even if they are passable maybe we can fix them.  
TAP comes with a metadata store where Source and Image Scan results and SBOMs are stored.  
  
Lets use the dedicated insight CLI to query the CVEs in our newly built image:  
  
First we need to retireve an access token from the cluster that has the correct RBAC for accessing the metadata store:
```execute
export METADATA_STORE_ACCESS_TOKEN=$(kubectl get secrets -n metadata-store -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='metadata-store-read-write-client')].data.token}" | base64 -d)
```
  
We then need to export the CA certificate of the metadata store so that we can verify the TLS certificate when interacting with the system:
```execute
kubectl get secret app-tls-cert -n metadata-store -o json | jq -r '.data."ca.crt"' | base64 -d > ~/metadata-store-ca.crt
```
  
Now we can setup our connection to the Metadata store and begin querying for information:
```execute
insight config set-target https://metadata-store-app.metadata-store.svc.cluster.local:8443 --ca-cert ~/metadata-store-ca.crt
```

Lets grab our images digest:
```execute
export IMAGE_SHA=$(kubectl get images.kpack.io java-web-app -o json | jq -r .status.latestImage | cut -d "@" -f2 -)
```

And finally lets look at our scan results:
```execute
insight image vulnerabilities -d $IMAGE_SHA
```
  
This can also be exported in a JSON format making it easy to write automations around:
```execute
insight image vulnerabilities -d $IMAGE_SHA --format json
```

Not only can we search by image. Because the data is stored in the metadata stores database we can search for example accross all images for a specific CVE if we need to figure out what is effected by a specific issue.  
As an example lets look at the vulnerability CVE-2020-16156. this is a security vulnerability with CPAN 2.28 that allow signature verification bypassing. this is a common CVE found in some common packages for example perl.  
Lets find all the images that have this CVE:  
```execute
insight vuln images -c CVE-2020-16156
```

As we can see, via a single simple command we can know exactly which image and which version of those images are vulnerable to this attack surface and that makes the detection phase very simple and we can pass this on to our developers to work on a fix in a much faster and percise manner.
