pipeline {
    agent none
    environment {
        ENV_DOCKER = credentials('dockerhub')
        DOCKERIMAGE = "dummy/dummy"
        EKS_CLUSTER_NAME = "demo-cluster"
        SONAR_TOKEN = credentials('sonar-token')
    }
    stages {
        stage('build') {
            agent {
                docker { image 'openjdk:11-jdk' }
            }
            steps {
                sh 'chmod +x gradlew && ./gradlew build jacocoTestReport'
                stash includes: 'build/**/*', name: 'testReport'
            }
        }
        stage('sonarqube') {
            agent {
                docker { image 'sonarsource/sonar-scanner-cli:latest' }
            }
            steps {
                unstash 'testReport'
                sh 'sonar-scanner'
            }
        }
        stage('docker build') {
            steps {
                sh 'echo docker build'
            }
        }
        stage('docker push') {
            steps {
                sh 'echo docker push!'
            }
        }
        stage('Deploy App') {
            steps {
                sh 'echo deploy to kubernetes'
            }
        }
    }
}