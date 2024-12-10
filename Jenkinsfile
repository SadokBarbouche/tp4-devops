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

        stage('Print Environment Variables') {
            steps {
                script {
                    // Print environment variables
                    echo "ACR_LOGIN_SERVER: ${ACR_LOGIN_SERVER}"
                    echo "ACR_USERNAME: ${ACR_USERNAME}"
                    echo "IMAGE_NAME: ${IMAGE_NAME}"
                    echo "IMAGE_TAG: ${IMAGE_TAG}"
                    // Avoid printing sensitive information like ACR_PASSWORD
                }
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
                    sh "docker build -t ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Login to ACR') {
            steps {
                script {
                    // Login to Azure Container Registry using the credentials
                    sh "echo ${ACR_PASSWORD} | docker login ${ACR_LOGIN_SERVER} -u ${ACR_USERNAME} --password-stdin"
                }
            }
        }

        stage('Push Docker Image to ACR') {
            steps {
                script {
                    // Push the Docker image to ACR
                    sh "docker push ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
    }

    post {
        always {
            mail to: 'bribesh1234@gmail.com',
                 subject: "Pipeline \${BUILD_NUMBER} - \${BUILD_STATUS}",
                 body: "Check Jenkins for details."
        }
    }
}
