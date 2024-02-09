pipeline {
    agent any
    
    environment {
        AWS_ACCESS_KEY_ID     = credentials('e6885355-a16d-4107-be24-67ee0c35acec')
        
    }

    parameters {
        choice(
            choices: ['apply', 'destroy'],
            description: 'Terraform action to apply or destroy',
            name: 'action'
            )
        
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

    stage('Terraform Init') {
        steps {
              
            script {
                    // sh 'rm -rf .terraform*'
                    // sh 'rm -rf terraform*'
                    sh 'terraform init'
                }
            }
        }

        

    stage('Terraform Plan') {
        steps {
               
            script {
                    sh 'terraform plan'
                }
            }
        }
    
    

    stage('Terraform Apply') {
        steps {
            script {
                if(params.action == 'apply'){
                    sh 'terraform apply -auto-approve'
                } else {
                    sh 'terraform destroy -auto-approve'
                }
            }
            }
        }
    }
}