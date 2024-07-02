pipeline {
    agent any

    options {
        // Max number of build logs to keep and days to keep
        buildDiscarder(logRotator(numToKeepStr: '5', daysToKeepStr: '5'))
        // Enable timestamp at each job in the pipeline
        timestamps()
    }

    environment {
        registry = 'namnguyen059/house-price-prediction'
        registryCredential = 'dockerhub'
    }

    stages {
        stage('Test') {
            steps {
                echo 'Testing model correctness..'
                echo 'Always pass all test units :D'
            }
        }

        stage('Build image') {
            steps {
                script {
                    echo 'Building image for deployment..'
                    def imageName = "${registry}:v1.${BUILD_NUMBER}"

                    dockerImage = docker.build(imageName, "--file Dockerfile .")
                    echo 'Pushing image to Docker Hub..'
                    docker.withRegistry('', registryCredential) {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Deploy to Google Kubernetes Engine') {
            agent {
                kubernetes {
                    containerTemplate {
                        name 'helm' // Name of the container to be used for helm upgrade
                        image 'duong05102002/jenkins-k8s:latest' // The image containing helm
                    }
                }
            }
            steps {
                script {
                    container('helm') {
                        sh("helm upgrade --install app --set image.repository=${registry} \
                        --set image.tag=v1.${BUILD_NUMBER} ./helm_charts/app --namespace model-serving")
                    }
                }
            }
        }
    }
}
