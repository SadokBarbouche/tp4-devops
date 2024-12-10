pipeline {
    agent any

    environment {
        ACR_LOGIN_SERVER = 'myacrregistry4.azurecr.io' // ACR login server URL
        IMAGE_NAME       = 'my-flask-app'              // Name of the image to be built and pushed
        IMAGE_TAG        = 'latest'                    // Tag for the Docker image
        GIT_REPO         = "https://github.com/SadokBarbouche/tp4-devops/"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: "${env.GIT_REPO}"
            }
        }

        stage('Ensure Docker is Installed') {
            steps {
                script {
                    // Check if Docker is installed
                    def dockerVersion = sh(script: 'docker --version', returnStdout: true).trim()
                    if (dockerVersion.contains('Docker version')) {
                        echo "Docker is already installed: ${dockerVersion}"
                    } else {
                        echo "Docker is not installed. Installing Docker..."
                        // Install Docker (example for Ubuntu)
                        sh '''
                            sudo apt-get update
                            sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
                            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
                            sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
                            sudo apt-get update
                            sudo apt-get install -y docker-ce
                        '''
                        // Verify installation
                        sh 'docker --version'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${env.ACR_LOGIN_SERVER}/${env.IMAGE_NAME}:${env.IMAGE_TAG}")
                }
            }
        }

        stage('Login to Azure') {
            steps {
                script {
                    // Use the Azure CLI to authenticate with the service principal
                    withCredentials([
                        string(credentialsId: 'ARM_SUBSCRIPTION_ID', variable: 'ARM_SUBSCRIPTION_ID'),
                        string(credentialsId: 'ARM_CLIENT_ID', variable: 'ARM_CLIENT_ID'),
                        string(credentialsId: 'ARM_CLIENT_SECRET', variable: 'ARM_CLIENT_SECRET'),
                        string(credentialsId: 'ARM_TENANT_ID', variable: 'ARM_TENANT_ID')
                    ]) {
                        sh '''
                            az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
                        '''
                    }
                }
            }
        }

        stage('Push Docker Image to ACR') {
            steps {
                withCredentials([
                    usernamePassword(credentialsId: 'acr-username', usernameVariable: 'ACR_USERNAME', passwordVariable: 'ACR_PASSWORD')
                ]) {
                    script {
                        docker.withRegistry("https://${env.ACR_LOGIN_SERVER}", "${env.ACR_USERNAME}:${env.ACR_PASSWORD}") {
                            docker.image("${env.ACR_LOGIN_SERVER}/${env.IMAGE_NAME}:${env.IMAGE_TAG}").push()
                        }
                    }
                }
            }
        }
    }
}
