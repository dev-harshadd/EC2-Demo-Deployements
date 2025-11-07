pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/dev-harshadd/EC2-Demo-Deployements.git'
            }
        }

        stage('Build with Maven') {
            options {
                // Set a timeout specific to the Maven build stage (e.g., 15 minutes)
                // This is often better than a pipeline-level timeout.
                timeout(time: 15, unit: 'MINUTES')
            }
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t microservice-app .'
            }
        }

        stage('Stop Old Container') {
            steps {
                sh '''
                docker ps -q --filter "name=microservice-app" | grep -q . && docker stop microservice-app && docker rm microservice-app || echo "No existing container"
                '''
            }
        }

        stage('Run New Container') {
            steps {
                sh 'docker run -d -p 8082:8082 --name microservice-app microservice-app'
            }
        }
    }
}
