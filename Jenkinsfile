pipeline {
  agent any
  tools { 
    maven 'Maven_3_8_4'  
  }
  environment {
    SNYK_API_TOKEN = credentials('SNYK_API') // Fetch the Snyk API token securely
    SONAR_TOKEN = credentials('SONAR_TOKEN_ID') // Fetch the Sonar token securely
  }

  stages {
    stage('Compile and Run Sonar Analysis') {
      steps {
        script {
          echo 'Running Sonar Analysis...'
          sh """
          mvn clean verify sonar:sonar \
            -Dsonar.projectKey=asgbuggywebapp62_asgbuggywebapp \
            -Dsonar.organization=asgbuggywebapp62 \
            -Dsonar.host.url=https://sonarcloud.io \
            -Dsonar.token=$SONAR_TOKEN
          """
        }
      }
    }
    
    stage('Test with Snyk') {
      steps {
        script {
          echo 'Running Snyk test...'
          sh """
          mvn snyk:test -Dorg.slf4j.simpleLogger.logLevel=error -fn
          """
        }
      }
    }
  }
}
