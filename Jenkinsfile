pipeline {
    agent { label 'minion' }

    environment {
        REPO_URL = 'https://github.com/alex1436183/tms_test.git'
        BRANCH_NAME = 'main'
        DEPLOY_SERVER = 'minion'  
        DEPLOY_DIR = '/var/www/myapp'
        IMAGE_NAME = 'myapp-image'
        CONTAINER_NAME = 'myapp-container'
    }

    stages {
        stage('Clone repository') {
            steps {
                cleanWs()
                echo "Cloning repository from ${REPO_URL}"
                git branch: "${BRANCH_NAME}", url: "${REPO_URL}"
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''#!/bin/bash
                echo "Building Docker image..."
                docker build -t ${IMAGE_NAME} .
                '''
            }
        }

        stage('Run Tests in Docker') {
            steps {
                sh '''#!/bin/bash
                echo "Running tests inside Docker container..."
                docker run --rm ${IMAGE_NAME} pytest tests/ --maxfail=1 --disable-warnings
                '''
            }
        }

        stage('Push Docker Image to Registry') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub-token', variable: 'DOCKER_TOKEN')]) {
                    sh '''#!/bin/bash
                    echo "Logging into Docker Hub..."
                    echo "$DOCKER_TOKEN" | docker login -u "your_dockerhub_username" --password-stdin
                    docker tag ${IMAGE_NAME} your_dockerhub_username/${IMAGE_NAME}:latest
                    docker push your_dockerhub_username/${IMAGE_NAME}:latest
                    '''
                }
            }
        }

        stage('Deploy to Server') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'agent-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                    sh '''#!/bin/bash
                    echo "Deploying project files to ${DEPLOY_SERVER}..."
                    ssh -i "$SSH_KEY" jenkins@${DEPLOY_SERVER} "mkdir -p ${DEPLOY_DIR}"
                    rsync -avz -e "ssh -i $SSH_KEY" . jenkins@${DEPLOY_SERVER}:${DEPLOY_DIR}/
                    echo "Deployment completed!"
                    '''
                }
            }
        }

        stage('Run Docker Container on Server') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'agent-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                    sh '''#!/bin/bash
                    echo "Starting Docker container on remote server..."
                    ssh -i "$SSH_KEY" jenkins@${DEPLOY_SERVER} "bash -c '
                        docker stop ${CONTAINER_NAME} || true &&
                        docker rm ${CONTAINER_NAME} || true &&
                        docker pull your_dockerhub_username/${IMAGE_NAME}:latest &&
                        docker run -d --name ${CONTAINER_NAME} -p 5000:5000 your_dockerhub_username/${IMAGE_NAME}:latest
                    '"
                    echo "Application deployed and running on ${DEPLOY_SERVER}!"
                    '''
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up workspace..."
        }
        failure {
            echo '❌ Pipeline failed! Check logs for details.'
        }
        success {
            echo '✅ Pipeline completed successfully!'
        }
    }
}
