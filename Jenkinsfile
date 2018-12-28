#!/usr/bin/env groovy

env.APP_NAME = 'laravel-test'
env.ECR_URL = 'https://257101242541.dkr.ecr.us-east-1.amazonaws.com'
env.ECR_USER = 'ecr:us-east-1:jenkins-aws'

node {
    try {
        stage('source') {
            // Checkout the app at the given commit sha from the webhook
            checkout scm
        }
        stage('build') {
            docker.withRegistry("$ECR_URL","$ECR_USER") {
                dockerImage = docker.build("$APP_NAME" + ":development", "-f ./build/docker/Dockerfile .")
            }
        }

        stage('docker push') {
            docker.withRegistry("$ECR_URL", "$ECR_USER") {
                dockerImage.push()
            }
        }

        stage('deploy to develop') {
            sh 'kubectl apply -f ./deploy/k8s/development/deployment.yaml'
            sh "kubectl apply -f ./deploy/k8s/development/service.yaml"
        }

        stage('promote to acceptance') {
            docker.withRegistry("$ECR_URL", "$ECR_USER") {
                dockerImage.tag('acceptance').push()
            }
        }

        stage('deploy to acceptance') {
            sh 'kubectl apply -f ./deploy/k8s/acceptance/deployment.yaml'
            sh "kubectl apply -f ./deploy/k8s/acceptance/service.yaml"
        }



    } catch(error) {
        throw error
    } finally {
        // Any cleanup operations needed, whether we hit an error or not
    }

}