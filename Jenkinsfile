pipeline {
    agent any

    environment {
        IMAGE_NAME = "santhu123456/myapp"
        TAG = "v1"
    }

    stages {
        stage('Clone Code') {
            steps {
                git 'https://github.com/Sushmitha1-16/multi-stage-example.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_NAME}:${TAG}")
                }
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh 'echo $PASSWORD | docker login -u $USERNAME --password-stdin'
                }
            }
        }

        stage('Push Image') {
            steps {
                script {
                    dockerImage.push()
                }
            }
        }

        stage('Clean Up') {
            steps {
                sh "docker rmi ${IMAGE_NAME}:${TAG}"
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
    }
}
