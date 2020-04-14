
pipeline {

agent { label 'minikube' }

  stages {

    stage('Checkout Source') {
      steps {
        git url:'https://github.com/stevenbill/test-jenkins.git', branch:'master'
      }
    }

    stage('Deploy App') {
      steps {
        script {
          kubernetesDeploy(configs: "nginx.yaml", kubeconfigId: "kubeconfig")
        }
      }
    }

  }

}
