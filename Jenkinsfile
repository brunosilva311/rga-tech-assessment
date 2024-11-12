pipeline {
    agent any

 
    environment {
        GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-key')
        GIT_TOKEN = credentials('git-credentials')
    }
 
    stages {
        stage('Install Terraform') {
            steps {
                script {
                    def terraformVersion = '1.8.5'
                    sh "wget https://releases.hashicorp.com/terraform/${terraformVersion}/terraform_${terraformVersion}_linux_amd64.zip"
                    sh "unzip -o terraform_${terraformVersion}_linux_amd64.zip"
                    sh 'chmod +x terraform'
                    sh 'mv terraform /usr/local/bin/terraform'
                    sh 'terraform version'
                }
            }
        }

        stage('Git Checkout') {
            steps {
                checkout scmGit(
                    branches: [[name: 'main']],
                    userRemoteConfigs: [[credentialsId: 'git-credentials', url: 'https://github.com/brunosilva311/rga-tech-assessment.git']]
                )
            }
        }
        
        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                script {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Action') {
            steps {
                script {
                    sh 'terraform $action --auto-approve'
                }
            }
        }
    }
}