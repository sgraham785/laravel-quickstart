#!/usr/bin/env groovy

env.APP_NAME = 'laravel-test'
env.ECR_URL = 'https://257101242541.dkr.ecr.us-east-1.amazonaws.com'
env.ECR_USER = 'ecr:us-east-1:jenkins-aws'

// def label = "worker-${UUID.randomUUID().toString()}"

// podTemplate(label: label, containers: [
//   containerTemplate(name: 'kubectl', image: 'lachlanevenson/k8s-kubectl:v1.8.8', command: 'cat', ttyEnabled: true)
// ]) {
node {
    try {
        stage('source') {
            // Checkout the app at the given commit sha from the webhook
            checkout scm
        }
        stage('build') {
            docker.withRegistry("$ECR_URL","$ECR_USER") {
                dockerImage = docker.build("$APP_NAME" + ":$BUILD_NUMBER", "-f ./build/docker/Dockerfile .")
            }
        }

        stage('docker push') {
            docker.withRegistry("$ECR_URL", "$ECR_USER") {
                dockerImage.push()
            }
        }

        stage('deploy to develop') {
            container('kubectl') {
                sh "kubectl get pods"
            }
        }
    } catch(error) {
        throw error
    } finally {
        // Any cleanup operations needed, whether we hit an error or not
    }

}
// }