# Techdocs

As this backstage instance was created from an [npx template](https://backstage.io/docs/getting-started/create-an-app#create-an-app) the backstage app already has the required plugin, source code and configuration.

To display the documentation from a repository we'll need to ['Register an existing component'](https://backstage.io/docs/getting-started/configuration#register-an-existing-component).

![](images/register-existing-component.png)

It may be possible to use [custom processors](https://backstage.io/docs/features/software-catalog/configuration#custom-processors) to import into backstage automatically.

## Adding docs to your repository

Techdocs uses mkdocs and this requires a `mkdocs.yml` file. This is necessary and you must define the pages in the `nav:` section like so:


A good example can also be found from mkdocs:
- [mkdocs.yml](https://github.com/mkdocs/mkdocs/blob/master/mkdocs.yml)
- [mkdocs documentation[(https://www.mkdocs.org/getting-started/)


For example in this repository:

```
site_name: Backstage Demo
site_description: 'Main documentation for Backstage features and platform APIs'
repo_url: https://github.com/bortington/backstage-test
edit_uri: edit/main/docs

plugins:
  - mermaid2

theme:
  name: material
  
nav:
  - Getting Started:
    - getting-started.md
    - techdocs.md
    - auth.md
    - techdocs.md
  - Deployment:
    - deployment.md
  - Samples:
    - mermaid-diagrams.md
  - Resources: resources.md
```

## Notes

Backstage techdocs does seem to check for updates, and after committing changes the following message appeared for me:
> A newer version of this documentation is now available, please refresh to view

All .md files must be defined in the `mkdocs.yml` file. However I recall a plugin or mechanism to enable automatic generation of the nav hierarchy.