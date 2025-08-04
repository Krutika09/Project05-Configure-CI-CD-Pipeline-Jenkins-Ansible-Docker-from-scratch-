pipeline {
    agent any

    environment {
        IMAGE_NAME = "krutika09/project05-ansible-cicd:v1"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Krutika09/Project05-Configure-CI-CD-Pipeline-Jenkins-Ansible-Docker-from-scratch-.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }
 	
	stage('Save Docker Image as TAR') {
            steps {
                sh 'docker save -o myapp.tar $IMAGE_NAME'
            }
        }

	stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $IMAGE_NAME
                        docker logout
                    '''
                }
            }
        }

        stage('Run Ansible Deployment') {
            steps {
                sh 'ansible-playbook -i ansible/inventory ansible/deploy.yml'
            }
        }
    }
}

