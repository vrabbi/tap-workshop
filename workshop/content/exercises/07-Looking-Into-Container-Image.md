So Cody now has a running deployment, and it conforms to the compliance standards that Alana defined. But Cody wants to see how his image was built and what the container looks like inside.
  
Lets get th latest version tag of our container:
```execute
IMAGE_REF=`kubectl get images.kpack.io java-web-app -o json | jq -r .status.latestImage`
```
Let's download the image so we can inspect it

```execute
skopeo copy docker://$IMAGE_REF docker-archive:///home/eduk8s/java-web-app.tar
```

Now lets look at the metadata attached to every TAP created image:  
```execute
skopeo inspect docker-archive:///home/eduk8s/java-web-app.tar | jq .Labels
```

As we can see alot of additional and helpful information is added as labels on contain images. For example lets see the type of data that is added:  
```execute
skopeo inspect docker-archive:///home/eduk8s/java-web-app.tar | jq '.Labels."io.paketo.stack.packages" | fromjson | .'
```

The output of that command shows us all of the system packages and the versions of them that are located within our image. Having this data can be extremely useful as it helps us understand which images are vulnerable when a new CVE is released for a system package.  
  
When building images, a very important best practice is the layers should not have the ability to change previous layers. This is very important if we want to automate re-builds and reconciliation of an image as that is the only way to allow us with confidence to switch out a layer for a newer version without completely rebuilding our image every time.  
  
To see this and to get a really good view of what our container image looks like we will use an open source tool called Dive.  
Dive allows us to inspect an image at every different layer and understand what changes were made to an image in a specific layer:
```execute
dive --source docker-archive /home/eduk8s/java-web-app.tar
```
If you play around with the tool, you can see that each layer touches different files and that they do not modify previous layers. By doing this we can be confident that auto re-basing of images which is performed by TAP is not only an efficient solution but is also secure and will not break your applications.

