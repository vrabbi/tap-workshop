So Cody now has a running deployment, and it conforms to the compliance standards that Alana defined. But Cody's just getting started. The supply chain is repeatable, so each new commit that Cody makes to the codebase will trigger another execution of the supply chain.

![Iterate](images/iterate.png)

Let's enhance the number formatting of the sensor data values.

```editor:select-matching-text
file: java-web-app/src/main/java/com/example/springboot/HelloController.java
text: "Greetings from Spring Boot + Tanzu!"
```

We've selected the code that retrieves the stored data of the sensors form the database and makes it available to the UI. Click below to add the code to enhance the number formatting for the UI.

```editor:replace-text-selection
file: java-web-app/src/main/java/com/example/springboot/HelloController.java
text: "Greetings %session_namespace% From Tanzu Application Platform"
```

Now, let's commit the change to the Git repo that is being monitored by our supply chain:

```execute
git -C ~/java-web-app commit -a -m "Application Change"
```

```execute
git -C ~/java-web-app push -u origin main
```

Wait a moment, and the supply chain will kick off. You will be able to see the build and deploy progress in the bottom terminal window. After the deploy, you can verify it is complete by again running:

```execute
tanzu apps workload get java-web-app
```

You will see the second build process listed for the build you triggered with your application update. The State for that build pod should show **Succeeded**. You can once again click on the URL displayed for your application Knative Serving Service, and we will see our code changes reflected in the deployed version.
