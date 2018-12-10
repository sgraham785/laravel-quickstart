#!/usr/bin/env groovy

pipeline {
    agent any
    environment {
        dockerImage = ''
        registry = "laravel-test"
        // registryCredential = 'dockerhub'
    }
    stages {
        stage('Cloning Source') {
            steps {
                // Checkout the app at the given commit sha from the webhook
                checkout scm
            }
        }
        stage('Build Image') {
            steps {
                sh "docker --version"
                // dockerImage = docker.build(registry + ":$BUILD_NUMBER", "./build/docker/Dockerfile")
                sh "docker build --file ./build/docker/Dockerfile --tag v.${registry}" + ":$BUILD_NUMBER" + " ."
                // Install dependencies, create a new .env file and generate a new key, just for testing
                // sh "composer install"
                // sh "cp .env.example .env"
                // sh "php artisan key:generate"

                // Run any static asset building, if needed
                // sh "npm install && gulp --production"
            }
        }

        // stage('test') {
        //     // Run any testing suites
        //     sh "./vendor/bin/phpunit"
        // }

        stage('deploy') {
            steps {
            // If we had ansible installed on the server, setup to run an ansible playbook
            // sh "ansible-playbook -i ./ansible/hosts ./ansible/deploy.yml"
                sh "echo 'WE ARE DEPLOYING'"
            }
        }
    // } catch(error) {
    //     throw error
    // } finally {
    //     // Any cleanup operations needed, whether we hit an error or not
    // }
    }
}