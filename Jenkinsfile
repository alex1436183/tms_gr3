pipeline {
    agent { label 'minion' }

    environment {
        REPO_URL = 'https://github.com/alex1436183/tms_test.git'
        BRANCH_NAME = 'main'
        VENV_DIR = 'venv'
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
                docker build -f Dockerfile -t myapp-image .
                echo "Docker image built successfully!"
                '''
            }
        }

        stage('Run Tests in Docker') {
            steps {
                sh '''#!/bin/bash
                echo "Running tests inside Docker container..."
                docker run --rm myapp-image pytest tests/ --maxfail=1 --disable-warnings
                '''
            }
        }

        stage('Parallel Deployment and Cleanup') {
            parallel {
                stage('Destroy Old Containers') {
                    steps {
                        sh '''#!/bin/bash
                        echo "Checking if a container with the name myapp-container exists..."

                        if [ $(docker ps -q -f name=myapp-container) ]; then
                            echo "Stopping and removing running container myapp-container..."
                            docker stop myapp-container || true
                            docker rm -f myapp-container || true
                        fi

                        if [ $(docker ps -aq -f name=myapp-container) ]; then
                            echo "Removing stopped container myapp-container..."
                            docker rm -f myapp-container || true
                        fi
                        '''
                    }
                }

                stage('Run Application in Docker') {
                    steps {
                        sh '''#!/bin/bash
                        echo "Starting application inside Docker container on port 5050..."
                        docker run -d -p 5050:5050 --name myapp-container myapp-image
                        echo "Application started inside Docker container!"
                        '''
                    }
                }
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
