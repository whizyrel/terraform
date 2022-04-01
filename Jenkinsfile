/* groovylint-disable DuplicateStringLiteral */
/* groovylint-disable-next-line CompileStatic */
pipeline {
    options {
        disableConcurrentBuilds()
    }

    agent {
        node {
            label 'node-initial'
        }
    }

    tools {
        git 'Default'
    }

    parameters {
        string(
            name: 'channel',
            defaultValue: '#jenkins-notification',
            description: 'What Slack Channel to use for Slack Messages '
        )
    }

    stages {
        stage('Make Terraform Script Executable') {
            when {
                expression { env.GIT_LOCAL_BRANCH == 'deploy' }
            }

            steps {
                sh '''
                    set -ex
                    echo "Making Shell script executable"
                    chmod +x ./terraform.sh
                '''
            }
        }

        stage('Run Terraform Script') {
            when {
                expression { env.GIT_LOCAL_BRANCH == 'deploy' }
            }

            steps {
                withCredentials([string(credentialsId: 'user-password', variable: 'USER_PWD')]) {
                    sh '''
                        set -ex
                        echo "Running Install Script"
                        ./terraform.sh $USER_PWD
                    '''
                }
            }
        }
    }

    post {
        failure {
            slackSend(
                color: 'danger',
                channel: params.channel,
                message: 'Terraform Installation Failed.',
            )
        }

        success {
            slackSend(
                color: 'good',
                channel: params.channel,
                message: """
                    Terraform Installation Succeeded `#$BUILD_NUMBER`.
                """,
            )
        }

        always {
            slackSend(
                color: 'good',
                channel: params.channel,
                message: 'Pipeline is finished'
            )
        }
    }
}
