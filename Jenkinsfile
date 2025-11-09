pipeline {
    agent any

    environment {
        IMAGE_NAME = 'microservice-app'
        IMAGE_TAG  = 'latest'
        CONTAINER_NAME = 'microservice-app'
        DOCKER_PORT = '8082'
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "Cloning source code..."
                git branch: 'main', url: 'https://github.com/dev-harshadd/EC2-Demo-Deployements.git'
            }
        }

        stage('Build Docker Image (with Maven inside Docker)') {
            steps {
                echo "Building Docker image using multi-stage Dockerfile..."
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
            }
        }

        stage('Stop Old Container (if exists)') {
            steps {
                echo "Checking and removing old running container..."
                sh '''
                if [ "$(docker ps -q -f name=${CONTAINER_NAME})" ]; then
                    echo "Stopping existing container..."
                    docker stop ${CONTAINER_NAME}
                    docker rm ${CONTAINER_NAME}
                else
                    echo "No existing container running."
                fi
                '''
            }
        }

        stage('Run New Container') {
            steps {
                echo "Running new container..."
                sh '''
                docker run -d \
                    --name ${CONTAINER_NAME} \
                    -p ${DOCKER_PORT}:${DOCKER_PORT} \
                    ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }

        stage('Verify Container') {
            steps {
                echo "Verifying container status..."
                sh '''
                docker ps | grep ${CONTAINER_NAME} && echo "✅ Container running successfully." || echo "❌ Container failed to start."
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Build and Deployment completed successfully!"
        }
        failure {
            echo "❌ Build or Deployment failed! Check logs above."
        }
        always {
            echo "🧹 Cleaning up unused Docker resources..."
            sh 'docker system prune -f || true'
        }
    }
}
