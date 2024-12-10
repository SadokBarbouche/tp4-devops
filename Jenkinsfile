pipeline {
    agent {
        docker {
            image 'docker:latest'  // Use the latest Docker image for the agent
            args '--privileged'  // Enable Docker-in-Docker by using the privileged mode
        }
    }

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
                    def dockerVersion = sh(script: 'docker --version', returnStdout: true).trim()
                    if (dockerVersion.contains('Docker version')) {
                        echo "Docker is installed: ${dockerVersion}"
                    } else {
                        error "Docker is not installed or not accessible. Please install Docker and ensure it is running."
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
