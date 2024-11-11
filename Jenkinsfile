pipeline {
    agent any

 
    environment {
        //GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-key')
        GIT_TOKEN = credentials('git-credentials')
    }
 
    stages {
        stage("Generating short-lived token") {
            steps {
                script {
                    sh(script: 'gcloud auth print-identity-token jenkins-sa@rga-gcp-tech-assessment.iam.gserviceaccount.com --audiences="//iam.googleapis.com/projects/205545633183/locations/global/workloadIdentityPools/jenkins/providers/jenkins" > /usr/share/token/credential.key', returnStdout: true)
                }
            }
        }
        
        stage("Storing credential file content into a variable") {
            steps {
                withCredentials([file(credentialsId: 'wif-config-file', variable: 'WIF')]) 
                    { 
                        sh ''' 
                            gcloud auth login --brief --cred-file=$WIF --quiet
                        '''
                    }
            }
        }

        stage('Git Checkout') {
            steps {
               git "https://${GIT_TOKEN}@github.com:brunosilva311/rga-tech-assessment.git"
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

        stage('Manual Approval') {
            steps {
                input "Approve?"
            }
        }
     
        stage('Terraform Apply') {
            steps {
                script {
                    sh 'terraform apply tfplan'
                }
            }
        }
    }
}