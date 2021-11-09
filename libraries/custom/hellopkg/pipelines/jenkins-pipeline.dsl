//Adjust your artifactory instance name/repository and your source code repository
def artifactory_name = "solengsaas"
def artifactory_repo = "ford-conan-local"
def repo_url = 'https://github.com/lsilvapvt/jfrog-conan-samples.git'
def repo_branch = 'main'

node {
    stage("Get project"){
        git branch: repo_branch, url: repo_url
    }

    stage("Configure Artifactory/Conan and build"){
        dir ('libraries/custom/hellopkg') {
          sh "pwd"
          sh "ls -la"
          sh "./pipelines/build-and-upload.sh"    
        }
    }
}