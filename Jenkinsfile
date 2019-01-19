#!/usr/bin/env groovy

env.APP_NAME = 'laravel-test'
env.ECR_URL = 'https://257101242541.dkr.ecr.us-east-1.amazonaws.com'
env.ECR_USER = 'ecr:us-east-1:jenkins-aws'

def label = 'dind-slave'
podTemplate(label: label) {
    node(label) {
        try {
            stage('source') {
                // Checkout the app at the given commit sha from the webhook
                checkout scm
                sh "git rev-parse --short HEAD > .git/commit-id"
                commitHash = readFile('.git/commit-id').trim()
                BUILD_HASH = "$BUILD_ID-$commitHash"
            }
            
            container('dind') {
            
                docker.withRegistry("$ECR_URL", "$ECR_USER") {
                        
                    stage('build') {
                        dockerImage = docker.build("$APP_NAME" + ":$BUILD_HASH", "-f ./build/docker/Dockerfile .")
                    }

                    stage('docker push') {
                        dockerImage.push() // pushes $BUILD_HASH
                        dockerImage.tag('development')
                        dockerImage.push('development')
                    }

                    stage('deploy to develop') {
                        sh 'kubectl apply -f ./deploy/k8s/development/deployment.yaml'
                        sh "kubectl apply -f ./deploy/k8s/development/service.yaml"
                    }

                    stage('promote to acceptance') {
                        dockerImage.tag('acceptance')
                        dockerImage.push('acceptance')
                    }

                    stage('deploy to acceptance') {
                        sh 'kubectl apply -f ./deploy/k8s/acceptance/deployment.yaml'
                        sh "kubectl apply -f ./deploy/k8s/acceptance/service.yaml"
                    }

                    stage('approve acceptance') {
                        input "Promote to Prod & Deploy?"
                    }

                    stage('promote to production') {
                        dockerImage.tag('production')
                        dockerImage.push('production')
                    }

                    stage('deploy to production') {
                        sh 'kubectl apply -f ./deploy/k8s/production/deployment.yaml --context prod-eks'
                        sh "kubectl apply -f ./deploy/k8s/production/service.yaml --context prod-eks"
                    }
                }
            }

        } catch(error) {
            throw error
        } finally {
            // Any cleanup operations needed, whether we hit an error or not
        }

    }
}