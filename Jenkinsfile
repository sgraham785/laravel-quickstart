#!/usr/bin/env groovy

env.APP_NAME = 'laravel-test'
env.ECR_URL = 'https://257101242541.dkr.ecr.us-east-1.amazonaws.com'
env.ECR_USER = 'ecr:us-east-1:jenkins-aws'

def label = "slave-${UUID.randomUUID().toString()}"
podTemplate(label: label, yaml: """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: dind
    image: docker:18.05-dind
    securityContext:
      privileged: true
    command: ['cat']
    tty: true
    volumeMounts:
    - name: dockersock
      mountPath: /var/run/docker.sock
    - name: dind-storage
      mountPath: /var/lib/docker
    - name: kubectl
      mountPath: /usr/local/bin/kubectl
    - name: kubeconfig
      mountPath: /.kube/config
  volumes:
    - name: dockersock
      hostPath:
        path: /var/run/docker.sock
    - name: kubectl
      hostPath:
        path: /usr/local/bin/kubectl
    - name: kubeconfig
      hostPath:
        path: /.kube/config
    - name: dind-storage
      persistentVolumeClaim:
        claimName: dind-storage
"""
  ) {
    node(label) {
        try {
            stage('source') {
                // Checkout the app at the given commit sha from the webhook
                checkout scm
                // sh "git rev-parse --short HEAD > .git/commit-id"
                // imageTag= readFile('.git/commit-id').trim()
            }
            container('dind') {
                
                stage('build') {
                    dockerImage = docker.build("$APP_NAME" + ":development", "-f ./build/docker/Dockerfile .")
                }

                stage('docker push') {
                    docker.withRegistry("$ECR_URL", "$ECR_USER") {
                        dockerImage.push("development")
                    }
                }

                stage('deploy to develop') {
                    sh 'kubectl apply -f ./deploy/k8s/development/deployment.yaml'
                    sh "kubectl apply -f ./deploy/k8s/development/service.yaml"
                }

                stage('promote to acceptance') {
                    dockerImage.tag('acceptance')
                    docker.withRegistry("$ECR_URL", "$ECR_USER") {
                        dockerImage.push('acceptance')
                    }
                }

                // stage('deploy to acceptance') {
                //     sh 'kubectl apply -f ./deploy/k8s/acceptance/deployment.yaml'
                //     sh "kubectl apply -f ./deploy/k8s/acceptance/service.yaml"
                // }
            }


        } catch(error) {
            throw error
        } finally {
            // Any cleanup operations needed, whether we hit an error or not
        }

    }
}