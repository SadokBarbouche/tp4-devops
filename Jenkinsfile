pipeline {
    agent any

    environment {
        IMAGE_NAME       = 'test'
        IMAGE_TAG        = 'latest'
        GIT_REPO         = "https://github.com/SadokBarbouche/tp4-devops/"
        DOCKER_HUB_REPO  = "sadokbarbouche/${IMAGE_NAME}"
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
                    def app = docker.build("${env.DOCKER_HUB_REPO}:${env.IMAGE_TAG}", "-f app/Dockerfile ./app")
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        sh """
                        echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                        """
                    }
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    sh """
                    docker push ${env.DOCKER_HUB_REPO}:${env.IMAGE_TAG}
                    """
                }
            }
        }
    }
}
