pipeline {
    agent none
    environment {
        ENV_DOCKER = credentials('dockerhub')
        DOCKERIMAGE = "sample-spring-boot"
        EKS_CLUSTER_NAME = "demo-cluster"
        SONAR_TOKEN = credentials('sonar-token')
        image = ''
    }
    stages {
        stage('build') {
            agent {
                kubernetes {
                    label 'spring'
                    defaultContainer 'jdk'
                }
            }
            steps {
                sh 'chmod +x gradlew && ./gradlew build jacocoTestReport'
                stash includes: 'build/**/*', name: 'build'
            }
        }
        stage('sonarqube') {
            agent {
                kubernetes {
                    label 'spring'
                    defaultContainer 'sonar'
                }
            }
            steps {
                unstash 'build'
                sh 'sonar-scanner'
            }
        }
        stage('docker build') {
            agent {
                kubernetes {
                    label 'spring'
                    defaultContainer 'docker'
                }
            }
            steps {
                echo 'Starting to build docker image'
                unstash 'build'

                script {
                    image = docker.build("$ENV_DOCKER_USR/$DOCKERIMAGE")
                }
            }
        }
        stage('docker push') {
            agent {
                kubernetes {
                    label 'spring'
                    defaultContainer 'docker'
                }
            }
            steps {
                echo 'Pushing image to registry'

                script {
                    docker.withRegistry('', 'dockerhub') {
                        image.push("$BUILD_ID")
                        image.push('latest')
                    }
                }
            }
        }
        stage('Deploy App') {
            agent {
                kubernetes {
                    label 'spring'
                    defaultContainer 'kubectl'
                }
            }
            steps {
                echo 'Deploying to kubernetes'

                withAWS(credentials:'aws-credentials') {
                    sh 'aws eks update-kubeconfig --name sre-primer'
                    sh 'chmod +x deployment-status.sh && ./deployment-status.sh'
                    sh "kubectl set image deployment sample-spring-boot -n matthew-oberlies springboot-sample=$ENV_DOCKER_USR/$DOCKERIMAGE:$BUILD_ID"
                }
            }
        }
    }
}