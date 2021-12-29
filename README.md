# Tanzu Application Platform Workshop

This is a workshop for delivering a narrative tour of Tanzu Application Platform.

## Installing the Workshop

To install the Tanzu Application Platform workshop in your own environment, the following prereqs must be in place in your Kubernetes cluster:

**Environment Values File**

Follow the docs for [Customizing the Environment Values File](install/values/README.MD). Ensure that you have the carvel tools **ytt** and **kapp** installed on your local machine.

**Harbor**

Follow the docs for [Installing Harbor](install/harbor/README.md)

**Tanzu Application Platform**

Install Tanzu Application Platform per the [Documentation](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/0.4/tap/GUID-install-intro.html)  
NOTE: Install the full profile and use the basic ootb supply chain

**Customize TAP**  

Follow the docs for [Customizing TAP For Demo](install/tap/README.md)

**Gitea**

Follow the docs for [Installing Gitea](install/gitea/README.md)

## Workshop

Finally, follow the docs for [Installing the Workshop](install/workshop/README.md)

The workshop will take a couple of minutes to start. Run:
```
kubectl get learningcenter
```
to verify everything is deployed.
