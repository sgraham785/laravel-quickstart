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
                commitTag= readFile('.git/commit-id').trim()
            }
            
            container('dind') {
            
                docker.withRegistry("$ECR_URL", "$ECR_USER") {
                        
                    stage('build') {
                        dockerImage = docker.build("$APP_NAME" + ":development", "-f ./build/docker/Dockerfile .")
                    }

                    stage('docker push') {
                        dockerImage.tag(commitTag)
                        dockerImage.push("development")
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
                        input "Deploy to prod?"
                        echo "Deployed"
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