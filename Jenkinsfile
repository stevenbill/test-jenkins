
pipeline {

agent { label 'master' }

  stages {

    stage('Checkout Source') {
      steps {
        git url:'https://github.com/stevenbill/test-jenkins.git', branch:'master'
      }
    }

    stage('Deploy App') {
      steps {
        script {
          kubernetesDeploy(configs: "php-apache.yaml", kubeconfigId: "kubeconfig")
        }
      }
    }

  }

}
