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
        snykSecurity(
          snykToken: "${SNYK_API_TOKEN}",
          snykOrg: 'reshma507',
          snykProject: 'reshma507/devsecops-with-kosmiktech'
        )
        sh 'mvn snyk:test -fn' // Run Snyk test with Maven
      }
    }

    stage('Build') { 
      steps { 
        withDockerRegistry([credentialsId: "dockerlogin", url: ""]) {
          script {
            app = docker.build("asg")
          }
        }
      }
    }

    stage('Push') {
      steps {
        script {
          docker.withRegistry('https://992382720273.dkr.ecr.us-east-1.amazonaws.com/asg', 'ecr:us-east-1:aws-credentials') {
            app.push("latest")
          }
        }
      }
    }

    stage("Jar Publish") {
      steps {
        script {
          echo '<--------------- Jar Publish Started --------------->'
          def server = Artifactory.newServer(url: registry + "/artifactory", credentialsId: "jfrog-cred")
          def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}"
          def uploadSpec = """{
            "files": [
              {
                "pattern": "jarstaging/(*)",
                "target": "kosmikdevsecops-libs-release/{1}",
                "flat": "false",
                "props" : "${properties}",
                "exclusions": [ "*.sha1", "*.md5"]
              }
            ]
          }"""
          def buildInfo = server.upload(uploadSpec)
          server.publishBuildInfo(buildInfo)
          echo '<--------------- Jar Publish Ended --------------->'
        }
      }
    }

    stage("Docker Build") {
      steps {
        script {
          echo '<--------------- Docker Build Started --------------->'
          app = docker.build(imageName + ":" + version)
          echo '<--------------- Docker Build Ended --------------->'
        }
      }
    }

    stage("Docker Publish") {
      steps {
        script {
          echo '<--------------- Docker Publish Started --------------->'
          docker.withRegistry(registry, 'jfrog-cred') {
            app.push()
          }
          echo '<--------------- Docker Publish Ended --------------->'
        }
      }
    }

  
  }
}
