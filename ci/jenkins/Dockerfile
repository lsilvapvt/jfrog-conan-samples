FROM jenkins/inbound-agent:4.11-1

USER root 

# install common tools 
RUN apt-get update
RUN apt-get -y install wget curl jq

# install python3 and pip 
RUN apt install python3 -y
RUN apt install python3-pip -y 

# install conan with pip 
RUN pip install conan

# install Conan with binary: https://docs.conan.io/en/latest/installation.html#install-the-binaries
# RUN wget https://github.com/conan-io/conan/releases/latest/download/conan-ubuntu-64.deb 
# RUN apt -y install ./conan-ubuntu-64.deb 
# RUN rm ./conan-ubuntu-64.deb

# install cmake with pip 
RUN pip install cmake 
ENV PATH="${PATH}:${HOME}/.local/bin"

# # install CMAKE https://blog.eldernode.com/install-cmake-on-ubuntu-and-debian/
# RUN wget https://github.com/Kitware/CMake/releases/download/v3.15.2/cmake-3.15.2.tar.gz
# RUN tar -zxvf ./cmake-3.15.2.tar.gz
# RUN rm ./cmake-3.15.2.tar.gz
# RUN cd cmake-3.15.2 && ./bootstrap && make && make install 

# install jfrog cli 
RUN wget -qO - https://releases.jfrog.io/artifactory/api/gpg/key/public | apt-key add -
RUN echo "deb https://releases.jfrog.io/artifactory/jfrog-debs xenial contrib" | tee -a /etc/apt/sources.list
RUN apt update
RUN apt install -y jfrog-cli-v2


USER jenkins 
