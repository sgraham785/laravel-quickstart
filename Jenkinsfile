#!/usr/bin/env groovy

env.ECR_URL = 'https://257101242541.dkr.ecr.us-east-1.amazonaws.com'
env.ECR_USER = 'ecr:us-east-1:jenkins-aws'

node {
    try {
        stage('source') {
            // Checkout the app at the given commit sha from the webhook
            checkout scm
        }
        stage('build') {
            docker.withRegistry($ECR_URL, $ECR_USER) {
                dockerImage = docker.build("$JOB_BASE_NAME" + ":$BUILD_NUMBER", "-f ./build/docker/Dockerfile .")
            }
        }

        stage('docker push') {
            docker.withRegistry($ECR_URL, $ECR_USER) {
                dockerImage.push()
            }
        }
    } catch(error) {
        throw error
    } finally {
        // Any cleanup operations needed, whether we hit an error or not
    }

}