## Sample Conan Package and CI builds


This foler contains a very simple Conan package created from the [Creating Packages - Getting Started tutorial](https://docs.conan.io/en/latest/creating_packages/getting_started.html) from the Conan documentation page. 

The purpose of this sample repository is to test and demonstrate how to automate the build and publish of a custom [Conan package - Recipe and Source in the same repo](https://docs.conan.io/en/latest/creating_packages/package_repo.html) - using a CI tools.


---

## Jenkins CI pipeline sample 

For notes on how to setup Jenkins to run Conan builds, please see [this page](../../ci/jenkins).

File [`jenkins-pipeline.dsl`](./pipelines/jenkins-pipeline.dsl) provides a very simple declarative pipeline sample that can be used to create a Jenkins pipeline item. This sample pipeline simply wraps up the git repo cloning and the execution of [`build-and-upload.sh`](./pipelines/build-and-upload.sh). 

That build script assumes the existence of the following pipeline parameters as environment variables:

- PIPELINE_PARAM_USERNAME - Artifactory's admin user ID
- PIPELINE_PARAM_PASSWORD - Artifactory's admin password 
- PIPELINE_PARAM_RT_API_URL - Artifactory's REST API endpoint (e.g. `https://myartifactory.com/artifactory/api/build`)
- PIPELINE_PARAM_CONAN_REPO_URL - Conan repository URL in Artifactory (e.g. `https://myartifactory.com/artifactory/api/conan/conan-repo`)


**Note**: this first build script sample does not use any capabilities of the Artifactory plugin for Jenkins and could be used with any other CI tool. A second pipeline example of using [Artifactory plugin's declarative functions]((https://github.com/jfrog/project-examples/blob/master/jenkins-examples/pipeline-examples/declarative-examples/conan-example/Jenkinsfile)) is planned for the near future.


---

## References

- [Use a generic CI with Conan and Artifactory](https://docs.conan.io/en/latest/howtos/generic_ci_artifactory.html?highlight=conan_build_info)

- [Example of a Jenkins declarative pipeline for a Conan project](https://github.com/jfrog/project-examples/blob/master/jenkins-examples/pipeline-examples/declarative-examples/conan-example/Jenkinsfile)

- [Jenkins Scripted Pipeline Syntax for Conan builds](https://www.jfrog.com/confluence/display/JFROG/Scripted+Pipeline+Syntax#ScriptedPipelineSyntax-ConanBuildswithArtifactory)

- [Jenkins Artifactory Plugin](https://www.jfrog.com/confluence/display/JFROG/Jenkins+Artifactory+Plug-in)

- [Configuring Jenkins Artifactory Plugin](https://www.jfrog.com/confluence/display/JFROG/Configuring+Jenkins+Artifactory+Plug-in)


---
