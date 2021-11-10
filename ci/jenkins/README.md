# Notes about Conan builds in Jenkins

### Custom Jenkins agent container image with Conan tools

The [Dockerfile](./Dockerfile) in this folder provides an example for building a custom image of a Jenkins agent with Conan and other tools required to build Conan applications and publish them to JFrog Platform instance (i.e. Artifactory).

---

## Using a custom container for executor nodes

The [Kubernetes plugin](https://plugins.jenkins.io/kubernetes/) allows for the definition of pod templates for executors.

The easiest way to use it is to deploy Jenkins as a helm chart, which installs and configures such plugin by default.



#### Deploy Jenkins to a Kubernetes cluster using Helm Charts

- [Documentation](https://github.com/jenkinsci/helm-charts/)

- Sample helm chart deployment commands  
  
  ```
  helm repo add jenkins https://charts.jenkins.io
  helm repo update
  kubectl create ns jenkins
  helm install jenkins  \
    -n jenkins \
    --set controller.serviceType=LoadBalancer \
    --set agent.image="myregistry/jenkins-inbound-agent-with-conan" \
    --set agent.tag="4.11-1-4" \
    -f helm/custom-values.yaml \
    jenkins/jenkins
  ```
  where the `agent.*` parameters should point to the container registry to which the custom container image of the Jenkins agent with Conan tools was published to along with the corresponding tag.
  
---

### Sample Conan package build 

Once the Jenkins server is up and running and the custom executor container image has been configured, then a Jenkins pipeline be configured for a Conan package build.

See the example of [`jenkins-pipeline.dsl`](../libraries/custom/hellopkg/pipelines/jenkins-pipeline.dsl) for a sample `hellopkg` conan recipe that gets built and published to an artifactory server.

---

## References

- [Use a generic CI with Conan and Artifactory](https://docs.conan.io/en/latest/howtos/generic_ci_artifactory.html?highlight=conan_build_info)

- [Example of a Jeknins declarative pipeline for a Conan project](https://github.com/jfrog/project-examples/blob/master/jenkins-examples/pipeline-examples/declarative-examples/conan-example/Jenkinsfile)

- [Jenkins Artifactory Plugin](https://www.jfrog.com/confluence/display/JFROG/Jenkins+Artifactory+Plug-in)

- [Configuring Jenkins Artifactory Plugin](https://www.jfrog.com/confluence/display/JFROG/Configuring+Jenkins+Artifactory+Plug-in)

- [Jenkins Scripted Pipeline Syntax for Conan builds](https://www.jfrog.com/confluence/display/JFROG/Scripted+Pipeline+Syntax#ScriptedPipelineSyntax-ConanBuildswithArtifactory)

---
