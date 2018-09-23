# Allowed --build-args
# --------------------
ARG SSH_TAR
ARG SET_TIMEZONE
ARG IMAGENAME=/jenkins:2.138.1



# Pull base image
# ---------------
FROM jenkins${IMAGENAME}

# Maintainer
# ----------
LABEL Maintainer.Name="Thomas Hucke" \
	  Maintainer.Mail="thucke@web.de" \
	  Version="1.0" \
	  Description="Enhancement of jenkins/jenkins image among others supporting docker host usage"

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV TERM=xterm \
	SET_TIMEZONE=${SET_TIMEZONE:-Europe/Berlin}

	
USER root

# Let Jenkins be sudoer
RUN apt-get update && \
	apt-get -y install apt-utils && \
    apt-get --no-install-recommends -y install sudo tzdata unzip tar iputils-ping iproute2 net-tools arp-scan dnsutils initscripts openssh-client bash-completion vim vnc4server fluxbox && \
    echo "jenkins ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    rm -rf /var/lib/apt/lists/* && \
	cp /usr/share/zoneinfo/${SET_TIMEZONE} /etc/localtime && \
	echo "${SET_TIMEZONE}" >  /etc/timezone && \
	unset SET_TIMEZONE


ADD passwd /usr/share/jenkins/ref/.vnc/passwd
ADD xstartup /usr/share/jenkins/ref/.vnc/xstartup
ADD dotXauthority /usr/share/jenkins/ref/.Xauthority
RUN chown jenkins:jenkins /usr/share/jenkins/ref/.vnc/passwd && \
	chown jenkins:jenkins /usr/share/jenkins/ref/.vnc/xstartup && \
	chown jenkins:jenkins /usr/share/jenkins/ref/.Xauthority && \
	chmod 0600 /usr/share/jenkins/ref/.vnc/passwd && \
	chmod 0600 /usr/share/jenkins/ref/.Xauthority

USER jenkins

COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy

ENV DOCKER_GID_ON_HOST ""

COPY git-restore-mtime /usr/local/bin/git-restore-mtime
COPY renderT3docsProject.sh /usr/local/bin/renderT3docsProject.sh
COPY jenkins.sh /usr/local/bin/jenkins.sh