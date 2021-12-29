Now that Cody has finished iterating over his code it is time to push his code to git and have TAP deploy the application for him.

Commit the configured application to Git, where it can be picked up by Tanzu Application Platform's Supply Chain Choreographer.

```execute
git -C ~/java-web-app add ~/java-web-app
```

```execute
git -C ~/java-web-app commit -a -m "Initial Commit of java-web-app"
```

```execute
git -C ~/java-web-app push -u origin main
```

Now Cody executes the *workload create* command to publish his new application. 

```execute
tanzu apps workload create java-web-app -f java-web-app/tap/workload.yaml -y
```

We'll start streaming the logs that show what Tanzu Application Platform does next:

```execute-2
tanzu apps workload tail java-web-app --since 1h
```

Let's see where Alana takes it from here!
