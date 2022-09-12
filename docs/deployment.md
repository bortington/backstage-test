# Deployment

As the backstage docs use docker images for both building and as a abuild artifact, it makes sense to use Azure Container Instances, which also supports container groups.

The `infrastructure` terraform config creates aci instance with an image that has been uploaded to a container registry. This will need to be changed as it is associated with a personal account.
A dns zone is referenced and a cname entry is added so the resulting url is `backstage.<domain>.com`.

There are a few things that need to be updated to reflect this new url, including:
- `app:baseUrl`, `backend:baseUrl`, `cors:origin`
- Your caddy container commands in the tf config, i.e. `commands = ["caddy", "reverse-proxy", "--from", "backstage.badbort.com", "--to", "localhost:7007"]`

Caddy is used as a sidecar container to obtain a certificate and serve as a reverse-proxy/ssl-termination to the backstage container.

## Workflow

There's 2 workflows in the project, one for building the container image, and the second for updating the infrastructure and deploying the latest published container image.

In addition, the latter also can be executed manually (dispatched workflow) and has a delete flag, allowing the cloud resources to be destroyed to save costs.