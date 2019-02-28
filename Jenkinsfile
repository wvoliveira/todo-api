#!groovy
import groovy.json.JsonSlurper
import groovy.json.JsonOutput

node {
    currentBuild.result = "SUCCESS"

    try {
        stage('Checkout') {
            step([$class: 'WsCleanup'])
            checkout scm
        }

        if (env.BRANCH_NAME == 'master') {

            stage('Build') {
                sh "./jenkins/build.sh testing"
            }

            stage('Push') {
                sh "./jenkins/push.sh testing"
            }

            stage('Deploy') {
                sh "./jenkins/deploy.sh testing"
            }

        }
    } catch (err) {
        currentBuild.result = "FAILURE"

        throw err
    }
}
