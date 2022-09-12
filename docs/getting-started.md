# Prerequisites

- Install [WSL 2](https://docs.microsoft.com/en-us/windows/wsl/install)
- Install docker
- Install docker-compose (Note: docker comes with [ComposeV2](https://docs.microsoft.com/en-us/windows/wsl/install) and could be used)


# Setup

### GitHub PAT
Create a GitHub PAT, give it SSO to the appropriate GitHub org if needed. For testing I used the following scopes:  
`notifications, read:discussion, read:enterprise, read:org, read:packages, read:project, read:repo_hook, read:user, repo`

### GitHub OAuth App
Create an OAuth app for the GitHub org. Go to Org settings -> Developer settings -> OAuth apps.

For localhost I used the following:
- Application name: `backstage-localhost-test`
- Homepage URL: `http://localhost:7007`
- Authorization callback URL: `http://localhost:7007/api/auth/github`

You will need the client secret later so save it somewhere temporarily.

### Setup env vars

I use docker-compose instead of docker commands as it allows us to store the configuration in a yaml file instead. Many examples also use backstage with the adminer container which can connect to a database in the 

The backstage configuration file uses environment variables

Create the file `backstage\.env` with the following contents with the values from the previous steps.
```
export AUTH_GITHUB_CLIENT_ID=XXXXX
export AUTH_GITHUB_CLIENT_SECRET=XXXXXX
export GITHUB_TOKEN=XXXXX
```

The `.env` file is used by docker-compose and provides the secrets/config to backstage that shouldn't be committed to `app-config.yaml`. Since this file contains secrets you should never commit it and it should already be git ignored.


# Build

### Build the container image

I had issues building on a Windows host, but succeeded when doing so within my wsl 2 ubuntu instance. So instead of having to do any of that we use a multi-stage docker build. This has been provided and tweaked from the docs [multi-stage-build](https://backstage.io/docs/deployment/docker#multi-stage-build)

This simplifies the build process at the cost of a slow build. The first time you build will take a while.

Start a new terminal instance in the `backstage` directory. Run the following command:  
 `docker build . -t backstage`  
This should build using `backstage/dockerfile` and give it the tag `backstage`.

 
That's it!

Note: I had issues fetching some yarn packages and had to disable GlobalProtect. After a successful build it should be cached and you shouldn't need to disable GlobalProtect the next time.

 # Run

We've create an image and tagged it, so now all we need to do is run it.

Since we have a docker image with the tag backstage, our `docker-compose.yml` file should be successful in starting it. You can now run `docker compose up` which will run our image.


# Adding a repository

Once the backstage image is running you should be able to connect to it from http://localhost:7007/. The `app-config.yaml` comes bundled with a bunch of components already set up, so there should be some existing content you can browser.

To add your repository:
- Navigate to Home tab
- Click `CREATE COMPONENT`
- Click `REGISTER EXISTING COMPONENT`
- If your repository does not contain a `catalog-info.yaml` file then you must create it.  An example configuration:
    ```
    apiVersion: backstage.io/v1alpha1
    kind: Component
    metadata:
    name: berty
    description: An example of a Backstage application.
    annotations:
        github.com/project-slug: bortington/backstage
        backstage.io/techdocs-ref: dir:.
    spec:
        type: website
        owner: john@example.com
        lifecycle: experimental
    ```
    See [Descriptor Format of Catalog Entities](https://backstage.io/docs/features/software-catalog/descriptor-format) for more information about this file.
- Enter the full path to the entity file, which should be a `catalog-info.yaml` file. For example, `https://github.com/bortington/backstage-test/blob/main/catalog-info.yaml`.

In the current `app-config.yaml` file techdocs will generate the static documentation automatically as the `techdocs` `builder` setting is set to `local`.