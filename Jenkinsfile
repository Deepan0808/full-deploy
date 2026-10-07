pipeline {
    agent any
    
    tools{
      nodejs 'frontend'
    }
    
    environment {
      AWS_DEFAULT_REGION = 'us-east-2'
      CLOUDFRONT_DIST_ID= 'E3IVNN8OTX80H7'
      AWS_CREDENTIALS= credentials('aws-id')
      }
 
    stages {
    
       stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'git-creds',
                    url: 'https://github.com/Deepan0808/full-deploy.git'
             }
        }
        
        stage('Install') {
            steps {
                dir('frontend') {
                    sh 'npm ci'
                }
            }
        }
        
        stage('build') {
            steps {
                dir('frontend') {
                    sh 'npm run build'
                 }
             }
        }
 
         
         stage('Sonarqube Analysis') {
            steps {
                script {
                    def scannerHome = tool name: 'SonarQube', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                
             withSonarQubeEnv('SonarQube') {   
                withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                    sh """
                            ${scannerHome}/bin/sonar-scanner \
                            -Dsonar.projectKey=frontend \
                            -Dsonar.sources=frontend\
                            -Dsonar.host.url=http://localhost:9000 \
                            -Dsonar.login=${SONAR_TOKEN}
                            """
                         }
                    }
               } 
         }
    }

     
         stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate( abortPipeline: false, credentialsId: 'sonar-token')
                }
            }
        }
        
    stage('using Terraform'){
      steps{
        echo 'Creating AWS Service by Terraform'
        sh '''
          cd terraform
          terraform init
          terraform plan
          terraform apply -auto-approve
        '''
        echo 'Successfully Aws Services Created'
      }
    }
    
    stage('Terraform Outputs'){
      steps{
        echo 'Mentioning terrafrom Variables...'
        dir('Terraform'){
          script {
            env.S3_BUCKET= sh(
              script: "terraform output -raw s3_bucket_name", 
              returnStdout: true
            ).trim()
            
            env.CLOUDFRONT_DIST_ID= sh(
              script: "terraform output -raw cloudfront_dist_id", 
              returnStdout: true
            ).trim()
         
            echo "S3_BUCKET= ${env.S3_BUCKET}"
            echo "CLOUDFRONT_DIST_ID= ${env.CLOUDFRONT_DIST_ID}"
          }
        }
      }
    }
        
       stage('Deploy S3 Bucket'){
           steps{
               echo 'updating S3 Bucket'
               sh ''' 
               aws s3 sync frontend/dist/ \
               s3://$S3_BUCKET/ \
               --delete \
               --region $AWS_DEFAULT_REGION
               '''
               echo 'Frontend Uploaded Successfully'
       }      
     }
     
     stage('Cloudfront Deployment'){
          steps{
              echo 'Deploying...'
              sh ''' 
              aws cloudfront create-invalidation \
              --distribution-id E3IVNN8OTX80H7 \
              --paths "/*"
              '''
           }
       }
       
     stage('Build Docker Images'){
         steps{
             echo "Building Images"
             sh '''
             docker compose up -d
             '''
           }
        }
     }
 }       
       
