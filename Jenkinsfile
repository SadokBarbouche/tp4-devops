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
                    def app = docker.build("${env.ACR_LOGIN_SERVER}/${env.IMAGE_NAME}:${env.IMAGE_TAG}", "-f app/Dockerfile ./app")
                }
            }
        }

        stage('Login to Azure') {
            steps {
                script {
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
        withCredentials([usernamePassword(credentialsId: 'acr-username-password', usernameVariable: 'ACR_USERNAME', passwordVariable: 'ACR_PASSWORD')]) {
            script {
                // Perform Docker login
                sh "docker login ${env.ACR_LOGIN_SERVER} -u ${ACR_USERNAME} -p ${ACR_PASSWORD}"
                
                // Push the Docker image to ACR
                sh """
                docker tag ${env.IMAGE_NAME}:${env.IMAGE_TAG} ${env.ACR_LOGIN_SERVER}/${env.IMAGE_NAME}:${env.IMAGE_TAG}
                docker push ${env.ACR_LOGIN_SERVER}/${env.IMAGE_NAME}:${env.IMAGE_TAG}
                """
            }
        }
    }
}

    }
}