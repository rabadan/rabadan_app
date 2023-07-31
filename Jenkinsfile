pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'docker.io/rabadanapp' // Замените на URL вашего Docker Registry
        DOCKER_IMAGE_NAME = 'rabadan_app_image' // Замените на имя Docker-образа вашего приложения
        RUBY_VERSION = '3.2.2' // Версия Ruby, которую вы хотите использовать
    }

    stages {
        stage('Checkout Source') {
            steps {
                git 'https://github.com/rabadan/rabadan_app.git'
            }
        }

        stage('Build Docker image') {
            steps {
                // Сборка Docker-образа с вашим приложением
                sh "docker build -t ${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER} ."
            }
        }

        stage('Push Docker image to registry') {
            steps {
                // Публикация Docker-образа в Docker Registry
                sh "docker login -u ${params.DOCKER_LOGIN} -p ${params.DOCKER_PASS} ${DOCKER_REGISTRY}"
                sh "docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}"
            }
        }

        stage('Deploy to production') {
            steps {
                sh "KUBECONFIG=/root/.kube/config kubectl apply -f rails-app-deployment.yaml"
                sh "KUBECONFIG=/root/.kube/config kubectl apply -f rails-app-service.yaml"
            }
        }
    }

    post {
        always {
            // Очистка рабочего пространства после сборки (опционально)
            cleanWs()
        }
    }
}
