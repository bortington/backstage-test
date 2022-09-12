# Authentication

You can configure providers with backstage and there exist many including GitHub and Azure Active Directory.

By default backstage will log you in as a single guest user, even if you have configured an identity provider. The code responsible for this can be found at `backstage\packages\backend\src\plugins\auth.ts`. I did not have any luck with using a GitHub username.

See: https://backstage.io/docs/auth/identity-resolver

Initial authentication setup with GitHub is described in [Getting Started](getting-starated.md).