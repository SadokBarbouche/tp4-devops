pipeline {
    agent any

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
    }

    post {
        always {
            mail to: 'bribesh1234@gmail.com',
                 subject: "Pipeline \${BUILD_NUMBER} - \${BUILD_STATUS}",
                 body: "Check Jenkins for details."
        }
    }
}
