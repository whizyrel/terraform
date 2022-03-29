/* groovylint-disable-next-line CompileStatic */
pipeline {
    options {
        disableConcurrentBuilds()
    }

    agent {
        node {
            label 'node-initial'
            customWorkspace './terraform-install'
        }
    }

    stages {
        stage('Terraform Install') {
            when {
                expression { BRANCH_NAME == 'main' || BRANCH_NAME == 'deploy' }
            }

            steps {
                sh '''
                    set -ex
                    echo "Making Shell script executable"
                    chmod +x ./terraform.sh
                '''
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
                channel: '#jenkins-noification',
                message: 'Terraform Install Failed.',
            )
        }

        success {
            slackSend(
                color: 'good',
                /* groovylint-disable-next-line DuplicateStringLiteral */
                channel: '#jenkins-noification',
                message: '''
                    Terraform Install Successful.

                    Terraform Version: `$(terraform version)`

                    Terraform Output:
                    ```
                    $(terraform output -json)
                    ```
                    Pipeline $PIPELINE_NAME: Terraform Install Successful.
                ''',
            )
        }

        always {
            slackSend(
                /* groovylint-disable-next-line DuplicateStringLiteral */
                color: 'good',
                channel: '#jenkins-notification',
                message: "Pipeline $PIPELINE_NAME is finished"
            )
        }
    }
}
