pipeline {
  agent any
  tools { 
    maven 'Maven_3_8_4'  
  }
  environment {
    // Fetch the Snyk API token securely from Jenkins Credentials
    SNYK_API_TOKEN = credentials('SNYK_API') // Jenkins Credentials Binding
  }

  stages {
    stage('Compile and Run Sonar Analysis') {
      steps {
        sh 'mvn clean verify sonar:sonar -Dsonar.projectKey=asgbuggywebapp62_asgbuggywebapp -Dsonar.organization=asgbuggywebapp62 -Dsonar.host.url=https://sonarcloud.io -Dsonar.token=77e1c5ae4c53c2eb150de51e863f82bae270de3c'
      }
    }
    
    stage('Test') {
      steps {
        echo 'Running Snyk test...'
        sh 'mvn snyk:test -fn' // Run Snyk test with Maven
      }
    }
  }
}
