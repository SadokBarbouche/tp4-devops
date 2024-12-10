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
                git branch: 'main', url: "${GIT_REPO}"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${ACR_LOGIN_SERVER}/${IMAGE_NAME}:${IMAGE_TAG}")
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
                        docker.withRegistry("https://${ACR_LOGIN_SERVER}", "${ACR_USERNAME}:${ACR_PASSWORD}") {
                            docker.image("${ACR_LOGIN_SERVER}/${IMAGE_NAME}:${IMAGE_TAG}").push()
                        }
                    }
                }
            }
        }
    }
}
