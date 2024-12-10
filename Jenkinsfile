pipeline {
    agent any

    environment {
        ACR_LOGIN_SERVER = 'myacrregistry4.azurecr.io'   // ACR login server URL
        ACR_USERNAME     = credentials('acr-username')    // ACR username from Jenkins credentials
        ACR_PASSWORD     = credentials('acr-password')    // ACR password from Jenkins credentials
        IMAGE_NAME       = 'my-flask-app'                // Name of the image to be built and pushed
        IMAGE_TAG        = 'latest'                      // Tag for the Docker image
    }

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/SadokBarbouche/tp4-devops/'
            }
        }

        stage('Initialize Terraform') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Plan Infrastructure') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Apply Infrastructure') {
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image using the Dockerfile in your repository
                    docker.build("${ACR_LOGIN_SERVER}/${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Login to ACR') {
            steps {
                script {
                    // Login to Azure Container Registry using the credentials
                    docker.withRegistry("https://${ACR_LOGIN_SERVER}", "${ACR_USERNAME}:${ACR_PASSWORD}") {
                        // This block will use the registry credentials for the following steps
                    }
                }
            }
        }

        stage('Push Docker Image to ACR') {
            steps {
                script {
                    // Push the Docker image to ACR
                    docker.withRegistry("https://${ACR_LOGIN_SERVER}", "${ACR_USERNAME}:${ACR_PASSWORD}") {
                        docker.image("${ACR_LOGIN_SERVER}/${IMAGE_NAME}:${IMAGE_TAG}").push()
                    }
                }
            }
        }
    }

    post {
        always {
            mail to: 'bribesh1234@gmail.com',
                 subject: "Pipeline ${env.BUILD_NUMBER} - ${currentBuild.currentResult}",
                 body: "Check Jenkins for details."
        }
    }
}
