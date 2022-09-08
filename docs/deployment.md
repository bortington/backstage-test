# Deployment

As the backstage docs use docker images for both building and as a abuild artifact, it makes sense to use Azure Container Instances, which also supports container groups.

The `infrastructure` terraform config creates aci instance with an image that has been uploaded to a container registry. This will need to be changed as it is associated with a personal account.