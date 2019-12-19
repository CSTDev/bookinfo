# Tekton pipeline to build the services

### Secrets
There are several secrets that need to be in your cluster in order for these to work these, are all base64 encoded.

##### slackwebhookurl
Required for the slack-notify task to talk to your slack web app [see here for help setting up](https://github.com/technosophos/slack-notify)

```
apiVersion: v1
kind: Secret
metadata: 
  name: slackwebhookurl
type: Opaque
data:
  url: <slack-web-hook-url>
```

##### aws-settings
Your account id and region

```
---
apiVersion: v1
kind: Secret
metadata:
  name: aws-settings
type: Opaque
data:
  AWS_ACCOUNT: <account-id>
  AWS_REGION: <region>
```

##### flux-git-auth
Required to allow flux access to your repository to read and update [see here](https://docs.fluxcd.io/en/stable/guides/use-git-https.html)

```
---
apiVersion: v1
kind: Secret
metadata:
  name: flux-git-auth
type: Generic
data:
  GIT_AUTHUSER: <git-username>
  GIT_AUTHKEY: <personal access token>
```