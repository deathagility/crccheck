pipeline {
    agent any

    stages {
        stage('Git Cloning') {
            steps {
                echo 'Cloning git repo'
                git url: 'https://github.com/deathagility/crccheck.git',  branch: 'sit-dev'
            }
        }
        stage('Build Docker Image') {
            steps {
                echo 'Building the image'
                sh 'docker build -t crccheck-dev:v1 .'
            }
        }
        stage('Push to Docker Hub') {
            steps {
                echo 'Pushing to Docker Hub'
                withCredentials([usernamePassword(credentialsId: 'dockerhub-demo', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                    echo "${PASS}" | docker login --username "${USER}" --password-stdin
                    docker tag crccheck-dev:v1 ${USER}/crccheck-dev:v1
                    docker push ${USER}/crccheck-dev:v1
                    '''
                }
            }
        }
        stage('Integrate Remote kubernetess with Jenkins') {
            steps {
                withCredentials([string(credentialsId: 'SECRET_TOKEN_k8s', variable: 'KUBE_TOKEN')]) {
                    sh '''
                    curl -LO "https://storage.googleapis.com/kubernetes-release/release/v1.20.5/bin/linux/amd64/kubectl"
                    chmod u+x ./kubectl
                    export KUBECONFIG=$(mktemp)
                    ./kubectl config set-cluster tdev-bam --server=https://172.19.3.230:6443 --insecure-skip-tls-verify=true
                    ./kubectl config set-credentials jenkins --token=${KUBE_TOKEN}
                    ./kubectl config set-context tdev-bam01 --cluster=tdev-bam --user=jenkins --namespace=tdev-bam03
                    ./kubectl config use-context tdev-bam01
                    ./kubectl apply -f service.yaml
                    ./kubectl apply -f deployment.yaml
                    ./kubectl apply -f ingress.yaml
                    '''
                }
            }
        }
    }
}
