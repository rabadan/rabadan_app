pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'rabadanapp' // Замените на URL вашего Docker Registry
        DOCKER_IMAGE_NAME = 'rabadan_app_image' // Замените на имя Docker-образа вашего приложения
        RUBY_VERSION = '3.2.2' // Версия Ruby, которую вы хотите использовать
        DOCKER_LOGIN = credentials('DOCKER_LOGIN')
        DOCKER_PASS = credentials('DOCKER_PASS')
    }

    stages {
        stage("Env Build Number"){
          steps{
            echo "The build number is ${env.BUILD_NUMBER}"
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
                sh "docker login -u ${DOCKER_LOGIN} -p ${DOCKER_PASS} ${DOCKER_REGISTRY}"
                sh "docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}"
            }
        }

        stage('Run tests') {
            steps {
                // Запуск тестов с помощью RSpec и сохранение результатов в файл junit.xml
                sh 'docker run --rm ${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER} bundle exec rspec --format RspecJunitFormatter --out junit.xml'
            }
            post {
                // Архивирование результатов тестов
                always {
                    junit 'junit.xml'
                }
            }
        }

        stage('Deploy to production') {
            steps {
                sh "kubectl apply -f rails-app-deployment.yaml"
                sh "kubectl apply -f rails-app-service.yaml"
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
