pipeline {
    agent any

    environment {
        ACR_LOGIN_SERVER = 'myacrregistry4.azurecr.io'
        IMAGE_NAME       = 'my-flask-app'
        IMAGE_TAG        = 'latest'
        GIT_REPO         = "https://github.com/SadokBarbouche/tp4-devops/"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: "${env.GIT_REPO}"
            }
        }

        stage('Verify Docker Installation') {
            steps {
                script {
                    sh 'docker --version'
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
                    withCredentials([
                        string(credentialsId: 'azure-arm-subscription-id', variable: 'ARM_SUBSCRIPTION_ID'),
                        string(credentialsId: 'azure-client-id', variable: 'ARM_CLIENT_ID'),
                        string(credentialsId: 'azure-client-secret', variable: 'ARM_CLIENT_SECRET'),
                        string(credentialsId: 'azure-tenant-id', variable: 'ARM_TENANT_ID')
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
                    usernamePassword(credentialsId: 'acr-username-password', usernameVariable: 'ACR_USERNAME', passwordVariable: 'ACR_PASSWORD')
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
