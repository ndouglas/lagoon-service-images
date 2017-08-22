node {
  def docker_compose = "docker run -t --rm -e BUILD_TAG=\$BUILD_TAG -v \$WORKSPACE:\$WORKSPACE -v /var/run/docker.sock:/var/run/docker.sock -w \$WORKSPACE docker/compose:1.13.0 -f docker-compose.ci.yaml -p lagoon"
  env.SAFEBRANCH_NAME = env.BRANCH_NAME.toLowerCase().replaceAll('%2f','-')

  deleteDir()

  stage ('Checkout') {
    checkout scm
  }

  lock('minishift') {
    ansiColor('xterm') {
      try {
        parallel (
          'start services': {
            stage ('build base images') {
              sh "./buildBaseImages.sh"
            }
            stage ('start services') {
              sh "${docker_compose} build --pull"
              sh "${docker_compose} up -d --force"
            }
          },
          'start openshift': {
            stage ('start openshift') {
              sh './startOpenShift.sh'
            }
          }
        )
      } catch (e) {
        echo "Something went wrong, trying to cleanup"
        cleanup(docker_compose)
        throw e
      }

        parallel (
          '_tests': {
              stage ('run tests') {
                try {
                  sh "${docker_compose} run --rm tests ansible-playbook /ansible/playbooks/node.yaml"
                } catch (e) {
                  echo "Something went wrong, trying to cleanup"
                  cleanup(docker_compose)
                  throw e
                }
                cleanup(docker_compose)
              }
          },
          'webhook-handler logs': {
              stage ('webhook-handler') {
                sh "${docker_compose} logs -f webhook-handler"
              }
          },
          'webhooks2tasks logs': {
              stage ('webhooks2tasks') {
                sh "${docker_compose} logs -f webhooks2tasks"
              }
          },
          'openshiftdeploy logs': {
              stage ('openshiftdeploy') {
                sh "${docker_compose} logs -f openshiftdeploy"
              }
          },
          'openshiftremove logs': {
              stage ('openshiftremove') {
                sh "${docker_compose} logs -f openshiftremove"
              }
          },
          'all logs': {
              stage ('all') {
                sh "${docker_compose} logs -f "
              }
          }
        )
      }
  }

  stage ('tag_push') {
    withCredentials([string(credentialsId: 'amazeeiojenkins-dockerhub-password', variable: 'PASSWORD')]) {
      sh 'docker login -u amazeeiojenkins -p $PASSWORD'
      sh "./buildBaseImages.sh tag_push amazeeiodev -${SAFEBRANCH_NAME}"
    }
  }

  if (env.BRANCH_NAME == 'master') {
    stage ('tag_push') {
      withCredentials([string(credentialsId: 'amazeeiojenkins-dockerhub-password', variable: 'PASSWORD')]) {
        sh 'docker login -u amazeeiojenkins -p $PASSWORD'
        sh "./buildBaseImages.sh tag_push amazeeio"
      }
    }
  }


}

def cleanup(docker_compose) {
  try {
    sh "${docker_compose} down -v"
    sh "./minishift/minishift delete"
  } catch (error) {
    echo "cleanup failed, ignoring this."
  }
}
