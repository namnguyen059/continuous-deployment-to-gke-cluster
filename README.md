Next, let's proceed with generating the token and configuring the Jenkins Kubernetes plugin.

### Step 1: Generate the Token for `jenkins-sa`

Run the following command to generate a token for the `jenkins-sa` service account:
```sh
kubectl -n model-serving create token jenkins-sa
```
This command should output a token. Make sure to copy this token.

### Step 2: Configure Jenkins Kubernetes Plugin with the Token

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

3. **Test the Connection:**
   - After entering the details, click the **Test Connection** button to verify that Jenkins can connect to the GKE cluster using the provided token.

### Step 3: Add Kubernetes Pod Template in Jenkins

1. Under the Kubernetes cloud configuration, click **Add Pod Template**.
2. Provide the following details for the pod template:
   - **Name**: A name for the pod template.
   - **Namespace**: The namespace where the pod will run (`model-serving`).
   - **Labels**: A label to identify this pod template.
3. Configure the container details:
   - **Name**: A name for the container.
   - **Docker Image**: The Docker image to use for the Jenkins agent.
   - **Command**: (optional) Command to run inside the container.
   - **Args**: (optional) Arguments for the command.

### Step 4: Test the Configuration

1. Create a new Jenkins job or configure an existing one.
2. Under the **Build Environment** section, check **Restrict where this project can be run**.
3. In the **Label Expression** field, enter the label you specified in the pod template.
4. Save and run the job to ensure it triggers a Kubernetes pod in your GKE cluster.
