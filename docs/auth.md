# Authentication

By default backstage will log you in as a single guest user, even if you have configured an identity provider.

Changes must be made to `backstage\packages\backend\src\plugins\auth.ts` to add support for users after logging in with the provider.