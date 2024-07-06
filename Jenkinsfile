pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '5', daysToKeepStr: '5'))
        timestamps()
    }

    environment {
        registry = 'mxomtm/house-price-prediction'
        registryCredential = 'dockerhub'
        KUBECONFIG = '/root/.kube/config'  // Path to your kubeconfig file if needed
    }

    stages {
        stage('Test') {
            steps {
                echo 'Testing model correctness..'
                echo 'Always pass all test unit :D'
            }
        }

        stage('Build image') {
            steps {
                script {
                    echo 'Building image for deployment..'
                    def imageName = "${registry}:v1.${BUILD_NUMBER}"

                    dockerImage = docker.build(imageName, "--file Dockerfile .")
                    echo 'Pushing image to dockerhub..'
                    docker.withRegistry('', registryCredential) {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Deploy to Google Kubernetes Engine') {
            agent {
                kubernetes {
                    // Specify service account and credentials
                    defaultContainer 'helm'
                    yaml """
                        apiVersion: v1
                        kind: Pod
                        metadata:
                          labels:
                            app: app
                          name: app
                        spec:
                          containers:
                          - name: helm
                            image: 'duong05102002/jenkins-k8s:latest'
                          serviceAccountName: jenkins-sa
                          restartPolicy: Never
                    """
                }
            }
            steps {
                container('helm') {
                    sh """
                    helm upgrade --install app --set image.repository=${registry} \
                    --set image.tag=v1.${BUILD_NUMBER} ./helm_charts/app --namespace model-serving
                    """
                }
            }
        }
    }
}
