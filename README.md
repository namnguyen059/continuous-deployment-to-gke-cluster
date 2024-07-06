Guide: https://github.com/duongngyn0510/continuous-deployment-to-gke-cluster/blob/master/README.md

### 4.4.5. Set up a connection to GKE by adding the cluster certificate key at Manage Jenkins/Clouds.

```sh
kubectl create serviceaccount jenkins-sa --namespace model-serving
kubectl create clusterrolebinding jenkins-sa-binding --clusterrole=cluster-admin --serviceaccount=model-serving:jenkins-sa 
kubectl create clusterrolebinding cluster-admin-default-binding --clusterrole=cluster-admin --user=system:serviceaccount:model-serving:default
```

**Step 1: Generate the Token for `jenkins-sa`**

Run the following command to generate a token for the `jenkins-sa` service account:
```sh
kubectl -n model-serving create token jenkins-sa
```
This command should output a token. Make sure to copy this token.

**Step 2: Configure Jenkins Kubernetes Plugin with the Token**

1. **Add Credentials in Jenkins:**
   - Go to **Manage Jenkins** > **Manage Credentials**.
   - Select the appropriate domain (e.g., **(global)**).
   - Click **Add Credentials**.
   - Choose **Secret text** as the kind.
   - Paste the token generated in Step 1 into the **Secret** field.
   - Provide an ID (e.g., `jenkins-sa-token`) and a description.

2. **Configure the Kubernetes Cloud in Jenkins:**
   - Go to **Manage Jenkins** > **Configure System**.
   - In the **Cloud** section, click **Add a new cloud** > **Kubernetes**.
   - Provide the following details:
     - **Name**: A name for your Kubernetes cloud configuration.
     - **Kubernetes URL**: `https://35.192.135.184`
     - **Kubernetes Namespace**: `model-serving`
     - **Credentials**: Select the credentials you added in the previous step.
     - **Jenkins URL**: The URL of your Jenkins instance (e.g., `http://<your-jenkins-url>:8080`).



