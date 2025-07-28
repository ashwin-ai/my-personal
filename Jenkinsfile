pipeline {
    agent any

    environment {
        MAVEN_HOME = tool 'Maven 3.9.9'
        IMAGE_NAME = '18121984/test1'
        DEPLOYMENT_NAME = 'springboot-app'
        SERVICE_NAME = 'springboot-service'
        NODE_PORT = '30036'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'feature', url: 'https://github.com/ashwin-ai/my-personal.git'
            }
        }

        stage('Build with Maven') {
            steps {
                withEnv(["PATH+MAVEN=${env.MAVEN_HOME}/bin"]) {
                    sh 'mvn clean package'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${IMAGE_NAME}:latest
                    '''
                }
            }
        }

        stage('Deploy to Minikube using Kubeconfig') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    sh '''
                        echo "🔁 Using kubeconfig from: $KUBECONFIG"

                        # Clean up old resources (if any)
                        kubectl --kubeconfig=$KUBECONFIG delete deployment ${DEPLOYMENT_NAME} --ignore-not-found=true
                        kubectl --kubeconfig=$KUBECONFIG delete service ${SERVICE_NAME} --ignore-not-found=true

                        # Apply Deployment
                        kubectl --kubeconfig=$KUBECONFIG apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${DEPLOYMENT_NAME}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ${DEPLOYMENT_NAME}
  template:
    metadata:
      labels:
        app: ${DEPLOYMENT_NAME}
    spec:
      containers:
      - name: springboot-container
        image: ${IMAGE_NAME}:latest
        ports:
        - containerPort: 8080
EOF

                        # Apply Service
                        kubectl --kubeconfig=$KUBE apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: ${SERVICE_NAME}
spec:
  type: NodePort
  selector:
    app: ${DEPLOYMENT_NAME}
  ports:
  - port: 8080
    targetPort: 8080
    nodePort: ${NODE_PORT}
EOF
                    '''
                }
            }
        }
    }

    post {
        failure {
            echo "❌ Something failed during build or deployment."
        }
        success {
            echo "✅ CI/CD complete: code built, pushed to Docker Hub, and deployed to Minikube!"
        }
    }
}
