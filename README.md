# Jenkins-K8s Deployment

### Overview

This project demonstrates deploying applications on a Kubernetes cluster using Jenkins for Continuous Integration and Continuous Deployment (CI/CD).

### BluePrint

The following diagram provides a high-level overview of the CI/CD pipeline:

![deploy](https://github.com/alilotfi23/jenkins-K8s/assets/91953142/86eaafd7-832f-4fae-81cd-e32f58ac1e48)

1. **Source Code Push**: A developer pushes the source code to a Git repository.
2. **Webhook Trigger**: The push event triggers a webhook to Jenkins.
3. **Build Image**: Jenkins pulls the source code and builds a Docker image.
4. **Push to Docker Hub**: The built Docker image is pushed to Docker Hub.
5. **Deploy on Kubernetes**: The Docker image is deployed to a K8s cluster.

### Prerequisites

Ensure you have the following installed and configured:

- Jenkins
- Docker
- Kubernetes Cluster
- Git
- Docker Hub Account

### Setup Instructions

#### 1. Jenkins Setup

- Install Jenkins on your server.
- Install the necessary plugins: Git, Docker, and Kubernetes.

#### 2. Git Repository

- Create a repository on GitHub or any Git service.
- Add your project files to the repository.

#### 3. Webhook Configuration

- In your Git repository, configure a webhook to trigger Jenkins builds on code push events.

#### 4. Jenkins Job Configuration

- **Source Code Management**: Configure Jenkins to pull the source code from your Git repository.
- **Build Triggers**: Set up the webhook to trigger the build process.
- **Build Steps**:
  - Use a Jenkins pipeline to build the Docker image.
  - Push the Docker image to Docker Hub.
- **Post-build Actions**: Deploy the Docker image to the Kubernetes cluster.

#### 5. Docker Hub Configuration

- Create a repository on Docker Hub to store your Docker images.

#### 6. Kubernetes Deployment

- Write Kubernetes deployment YAML files to deploy the Docker image from Docker Hub.
- Ensure your Kubernetes cluster is configured to pull images from Docker Hub.

### Jenkins Pipeline Script

sample Jenkins pipeline script:

```groovy
pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/your-repo.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("your-dockerhub-username/your-image-name:latest")
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials-id') {
                        docker.image("your-dockerhub-username/your-image-name:latest").push()
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                kubernetesDeploy configs: 'k8s/deployment.yaml', kubeConfig: [path: 'path/to/kubeconfig']
            }
        }
    }
}
```

### Kubernetes Deployment YAML

Create a `deployment.yaml` file for your Kubernetes deployment:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: your-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: your-app
  template:
    metadata:
      labels:
        app: your-app
    spec:
      containers:
      - name: your-app
        image: your-dockerhub-username/your-image-name:latest
        ports:
        - containerPort: 80
```

### Conclusion

By following the above steps, you can set up a Jenkins pipeline to automate the deployment of your applications on a Kubernetes cluster. This ensures a smooth CI/CD process, enabling rapid development and deployment.
