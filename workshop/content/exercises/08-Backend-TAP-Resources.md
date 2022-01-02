So Cody now has a running deployment, and it conforms to the compliance standards that Alana defined. But Cody wants to see what TAP actually created for him behind the seens when he applied the workload resource.
  
Lets take a look at all the resources that were actually created for us behind the seens. For this we will use a kubectl plugin called lineage:
```execute
kubectl-lineage workload java-web-app -A -o split --show-group
```

The output of that command shows us all of the resources that have been created by the TAP system based on that workload YAML.  
Using a bit of grep magic we can clean out this list to just show us the resource type and names in a concise manner:
```execute
kubectl-lineage workload java-web-app -A -o split --show-group --no-headers | grep '^[[:alpha:]]' - | grep -o '^\S*' -
```

Lets extract the resource YAMLs and see them in VSCode to see really what these resources define
```execute
kubectl-lineage workload java-web-app -A -o split --show-group --no-headers | grep '^[[:alpha:]]' - | grep -o '^\S*' - | while read line; do mkdir -p "/home/eduk8s/tap-resources/$(dirname "$line")" && kubectl get $line -o yaml | kubectl eksporter --keep metadata.labels,status - 2>/dev/null > /home/eduk8s/tap-resources/$line.yaml; done
```
  
This previous command has created cleaned up YAML files with our configurations under the tap-resources folder. lets see how they look in VSCode:

The first resource is our Image Repository resource for our source code
```editor:open-file
file: tap-resources/imagerepository.source.apps.tanzu.vmware.com/java-web-app.yaml
```
This resource declares the OCI bundle location where our source code is located.
  
The next resource we will look at is the Image Resource which is the definition that was generated to manage the container image for this application:
```editor:open-file
file: tap-resources/image.kpack.io/java-web-app.yaml
```
  
Once the image is created automatically a sourceresolver is created which will be used to pull the code from the OCI bundle above and pass that into the Kpack building process
```editor:open-file
file: tap-resources/sourceresolver.kpack.io/java-web-app-source.yaml
```
  
Once the code has been resolved by Kpack, the next object is the actual build of the image revision itself:
```editor:open-file
file: tap-resources/build.kpack.io/java-web-app-build-1.yaml
```
  
As part of the Build process, 2 other objects are created. A Pod where the build occurs, and a PVC used for caching so that future builds are more efficient 
```editor:open-file
file: tap-resources/pod/java-web-app-build-1-build-pod.yaml
```
```editor:open-file
file: tap-resources/persistentvolumeclaim/java-web-app-cache.yaml
```
  
Once the build has completed the next resource created is a Pod Intent Object which generates the begining of our app manifests based on the best practices and defaults configured in our supply chain:
```editor:open-file
file: tap-resources/podintent.conventions.apps.tanzu.vmware.com/java-web-app.yaml
```
  
The Next resource that is created is a tekton pipeline run that is used to generated our end application artifact which then instantiates a pod: (You can find these files under the folder path: **tap-resources/taskrun.tekton.dev/** and **tap-resources/pod/**)
  
The next resource created is the Cartographer Runnable which bundles our application artifacts into an OCI bundle that can be deployed to our cluster
```editor:open-file
file: tap-resources/runnable.carto.run/java-web-app-config-writer.yaml
```
  
Once this runnable is completed and our artifacts are in an OCI registry, the application is deployed using a cartographer deliverable resource
```editor:open-file
file: tap-resources/deliverable.carto.run/java-web-app.yaml
```
  
This deliverable instantiates a Kapp App resource.
```editor:open-file
file: tap-resources/app.kappctrl.k14s.io/java-web-app.yaml
```
  
The App resource then generates an Image Repository object to pull down the deliverable manifests:
```editor:open-file
file: tap-resources/imagerepository.source.apps.tanzu.vmware.com/java-web-app-delivery.yaml
```

The final high level resource that is created is our Knative Service resource
```editor:open-file
file: tap-resources/
```

The Knative service then generates all the needed ingress objects, services and deployments to run our application as can be viewed using the command:
```execute
kubectl get pod,service,revision --selector serving.knative.dev/service=java-web-app && kubectl get httpproxy --selector contour.networking.knative.dev/parent=java-web-app
```
  
To Retrieve the YAML definitions of all of our Knative deployed resource for the app, you can run the following command:
```execute
kubectl-lineage ksvc java-web-app -A -o split --show-group --no-headers | grep '^[[:alpha:]]' - | grep -o '^\S*' - | while read line; do mkdir -p "/home/eduk8s/tap-resources/$(dirname "$line")" && kubectl get $line -o yaml | kubectl eksporter --keep metadata.labels,status - 2>/dev/null > /home/eduk8s/tap-resources/$line.yaml; done
```  
  
As you can see, The Tanzu Application platform is handling a lot of tasks that are complex and combersome to deal with for us automatically in a secure, and standardized manner, allowing for reproducability, auditability and full visibility.

Just to see the difference in terms of amount of YAML generated by the system vs what we need to supply the system lets run the following command:

```execute
echo "WORKLOAD YAML LENGTH: " `kubectl eksporter workload java-web-app --keep labels | wc -l` && echo "GENERATED YAML LENGTH:" `( find /home/eduk8s/tap-resources/ -name '*.yaml' -print0 | xargs -0 cat ) | wc -l`
```



