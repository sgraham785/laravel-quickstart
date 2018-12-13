#!/usr/bin/env groovy

node {
    environment {
        ECR_URL = 'https://257101242541.dkr.ecr.us-east-1.amazonaws.com'
    }
    try {
        stage('source') {
            // Checkout the app at the given commit sha from the webhook
            checkout scm
        }
        stage('build') {
            docker.withRegistry($ECR_URL, 'ecr:us-east-1:jenkins-aws') {
                dockerImage = docker.build("$JOB_NAME" + ":$BUILD_ID", "-f ./build/docker/Dockerfile .")
            }
        }

        stage('docker push') {
            docker.withRegistry('https://257101242541.dkr.ecr.us-east-1.amazonaws.com', 'ecr:us-east-1:jenkins-aws') {
                dockerImage.push()
            }
        }
    } catch(error) {
        throw error
    } finally {
        // Any cleanup operations needed, whether we hit an error or not
    }

}