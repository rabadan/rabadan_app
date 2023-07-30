pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'github-credentials', url: 'https://github.com/rabadan/rabadan_app.git'
            }
        }

        stage('Install dependencies') {
            steps {
                sh 'bundle install'
            }
        }

        stage('Run tests') {
            steps {
                // Запуск тестов с помощью RSpec и сохранение результатов в файл junit.xml
                sh 'bundle exec rspec --format RspecJunitFormatter --out junit.xml'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
