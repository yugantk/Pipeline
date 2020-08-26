#!groovy

pipeline {
    agent any
    tools {
        maven 'maven3.6.3'
        jdk 'java8'
        }

    environment {
        //getting the current stable/deployed revision...this is used in undeloy.sh in case of failure...
        stable_revision = sh(script: 'curl -H "Authorization: Basic "$BASE64"" "https://api.enterprise.apigee.com/v1/organizations/dayakarg-eval/apis/HelloWorld/deployments" --ssl-no-revoke -x  | jq -r ".environment[0].revision[0].name"', returnStdout: true).trim()
    }

    stages {
       stage('Initial-Checks') {
       steps {
                bat "npm -v"
                bat "mvn -v"
                //echo "$apigeeUsername"
                //echo "Stable Revision: ${env.stable_revision}"
        }}  
        stage('Policy-Code Analysis') {
            steps {
               // bat "npm install -g apigeelint"
               bat "C:/Windows/System32/config/systemprofile/AppData/Roaming/npm/apigeelint -s HelloWorld/apiproxy/ -f codeframe.js"
            }
        }
        stage('Unit-Test-With-Coverage') {
            steps {
              script {
                   try {
                        // bat "npm install"
                        bat "npm test test/unit/*.js"
                      bat "npm run coverage test/unit/*.js"
                   } catch (e) {
                     throw e
                  } finally {
                    bat "cd coverage && cp cobertura-coverage.xml $WORKSPACE"
                       // bat([$class: 'CoberturaPublisher', coberturaReportFile: 'cobertura-coverage.xml'])
                    }
                }
            }
        }
        /*stage('Promotion') {
            steps {
                timeout(time: 2, unit: 'DAYS') {
                    input 'Do you want to Approve?'
                }
            }
        }*/
        stage('Deploy to test') {
            steps {
                 //deploy using maven plugin
                 
                 // deploy only proxy and deploy both proxy and 	config based on edge.js update
                //	bat "sh && sh deploy.sh"
                sh "mvn -f HelloWorld/pom.xml install -Ptest -Dusername=${apigeeUsername} -Dpassword=${apigeePassword} -Dapigee.config.options=update"
                
            }
        }
        stage('Integration Tests') {
            steps {
                script {
                    try {
                        // using credentials.sh to get the client_id and secret of the app..
                        // thought of using them in cucumber oauth feature
                        // bat "sh && sh credentials.sh"
                        bat "cd $WORKSPACE/test/integration && npm install"
                        bat "cd $WORKSPACE/test/integration && npm test"
                    } catch (e) {
                        //if tests fail, I have used an shell script which has 3 APIs to undeploy, delete current revision & deploy previous stable revision
                        bat "sh && sh undeploy.sh"
                        throw e
                    } finally {
                        // generate cucumber reports in both Test Pass/Fail scenario
                        bat "cd $WORKSPACE/test/integration && cp reports.json $WORKSPACE"
                        cucumber fileIncludePattern: 'reports.json'
                        build job: 'cucumber-report'
                    }
                }
            }
        }
    }
    }

/*

using shared library for slack reporting
    the lib groovy script must be placed in a vars folder in SCM
using build job to call a Freestyle project which sends the Cucumber reports to slack
    currently the cucumberSlackSend channel: 'apigee-cicd', json: '$WORKSPACE/reports.json' 
        option doesnt send the reports to Slack
*/
