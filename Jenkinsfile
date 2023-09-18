pipeline {
  agent any
  stages {
    stage('Build Docker Image') {
      steps {
        script {
          sh 'docker build -t alilotfi/$JOB_NAME:latest .'
        }
      }
    }
    stage('Deploy Docker Image') {
      steps {
        script {
          withCredentials([string(credentialsId: 'dockerhub-pwd', variable: 'dockerhubpwd')]) {
            sh 'docker login -u alilotfi -p ${dockerhubpwd}'
          }
          sh 'docker push alilotfi/$JOB_NAME:latest'
        }
      }
    }
    stage('Deploy App on k8s') {
      steps {
        sshagent(['k8s']) {
          sh "scp -o StrictHostKeyChecking=no deploy.yaml username@k8s-cluster-ip:/home/user-home"
          script {
            try {
              sh "ssh user-name@k8s-cluster-ip kubectl create -f ."
            } catch (error) {
              sh "ssh user-name@k8s-cluster-ip kubectl create -f ."
            }
          }
        }
      }
    }
  }
}
