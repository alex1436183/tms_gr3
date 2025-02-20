pipeline {
    agent { label 'minion' }

    environment {
        REPO_URL = 'https://github.com/alex1436183/tms_test.git'
        BRANCH_NAME = 'main'
        VENV_DIR = 'venv'
        IMAGE_NAME = 'myapp-image'
        CONTAINER_NAME = 'myapp-container'
        HOST_PORT = '5051'  // Используем другой порт для избежания конфликта
        CONTAINER_PORT = '5050'  // Порт внутри контейнера
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
                echo "Current directory before Docker build: $(pwd)"
                echo "Listing files in current directory before Docker build:"
                ls -l
                echo "Building Docker image..."
                docker build -f Dockerfile -t ${IMAGE_NAME} .
                echo "Docker image built successfully!"
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

        stage('Stop and Remove Old Container') {
            steps {
                sh '''#!/bin/bash
                if [ $(docker ps -q -f name=${CONTAINER_NAME}) ]; then
                    echo "Stopping and removing old container..."
                    docker stop ${CONTAINER_NAME} || true
                    docker rm -f ${CONTAINER_NAME} || true
                fi
                '''
            }
        }

        stage('Run Application in Docker') {
            steps {
                sh '''#!/bin/bash
                echo "Starting application inside Docker container on port ${HOST_PORT}..."
                docker run -d -p ${HOST_PORT}:${CONTAINER_PORT} --name ${CONTAINER_NAME} ${IMAGE_NAME}
                echo "Application started inside Docker container!"
                '''
            }
        }
    }

    post {
        always {
            sh '''#!/bin/bash
            echo "Cleaning up..."
            '''
        }
        failure {
            echo '❌ Pipeline failed! Check logs for details.'
        }
        success {
            echo '✅ Pipeline completed successfully!'
        }
    }
}
