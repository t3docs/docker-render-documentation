# dockerjenkins


A docker image to run a jenkins that can run docker commands inside a docker container.

Run with
 
docker run -p 8080:8080 -p 50000:50000 -v /var/run/docker.sock:/var/run/docker.sock -v /usr/bin/docker:/usr/bin/docker -v /var/lib/jenkins_home:/var/jenkins_home -e "DOCKER_GID_ON_HOST=$(cat /etc/group | grep docker: | cut -d: -f3)" oose/dockerjenkins

This will start a jenkins that can execute the docker binary inside the container but access the dockerd of the same host running the jenkins container. This may be userful for example when running shell scripts to build docker images. The "group id magic" is required to let the jenkins user in the container access the docker socket of the host. 

The approach taken here though useful in some cases can and should be replaced by a propperly configured and tls secured docker host that is used from inside the jenkins container over the "normal" docker remote protocol. Therefor set the url of the docker host to use as environment variable DOCKER_HOST for the jenkins container, mount a volume/directory with ca.pem, client certificate and key and configure DOCKER_CERT_PATH accordingly. The docker client binary can be mounted as shown a above, installed in docker with apt-get or use for example a docker gradle plugin that can talk to remote docker hosts.


For a german description see this blog as well https://www.oose.de/blogpost/jenkins-in-docker-und-mit-docker-und-fuer-docker/


