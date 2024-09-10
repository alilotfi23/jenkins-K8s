pipeline {
  agent any // Runs on any available agent/node

  stages {
    stage('Build Docker Image') {
      steps {
        script {
          sh 'docker build -t alilotfi/$JOB_NAME:latest .' // Builds Docker image with a tag based on the Jenkins job name
        }
      }
    }

    stage('Deploy Docker Image') {
      steps {
        script {
          withCredentials([string(credentialsId: 'dockerhub-pwd', variable: 'dockerhubpwd')]) {
            sh 'docker login -u alilotfi -p ${dockerhubpwd}' // Logs into Docker Hub with credentials
          }
          sh 'docker push alilotfi/$JOB_NAME:latest' // Pushes the Docker image to Docker Hub
        }
      }
    }

    stage('Deploy App on k8s') {
      steps {
        sshagent(['k8s']) { // Uses SSH agent credentials named 'k8s' for secure SSH operations
          sh "scp -o StrictHostKeyChecking=no deploy.yaml username@k8s-cluster-ip:/home/user-home" // Copies deploy.yaml to Kubernetes cluster
          script {
            try {
              sh "ssh user-name@k8s-cluster-ip kubectl create -f ." // Attempts to deploy Kubernetes resources
            } catch (error) {
              sh "ssh user-name@k8s-cluster-ip kubectl create -f ." // Retries deployment in case of failure
            }
          }
        }
      }
    }
  }
}
