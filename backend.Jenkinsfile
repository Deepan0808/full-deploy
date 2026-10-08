pipeline {
    agent any

    environment {
        AWS_CREDENTIALS= credentials('aws-id')
        AWS_REGION= 'us-east-2'
        
        DOCKER_HUB_USER = 'deepan0808'
        DOCKER_TAG = "v${BUILD_NUMBER}"
        
        EC2_HOST = '3.148.178.225'
        EC2_USER = 'ubuntu'
        
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
         stage('Ansible'){
           steps{
             dir('Ansible'){
               sshagent(['ec2-ssh-key']){
                 echo 'installing Software using ansible'
                 sh '''
                   ansible --version
                   ansible-playbook -i inventory.ini docker.yml
                   ansible-playbook -i inventory.ini kube.yml
                  
                 '''
                }
              }
           }
        }
     }
   }
