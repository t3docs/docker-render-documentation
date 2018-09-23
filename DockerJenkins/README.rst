
==============================================
Jenkins in docker used to render documentation
==============================================

.. default-role:: code
.. highlight:: shell

This is the official recipe to build a Docker image that supports 
calling die official Docker image t3docs/render-documentation out
of the running container.

:Authors:         TYPO3 Documentation Team
:Repository:      https://github.com/t3docs/docker-render-documentation
:Branch:          master
:Docker image:    t3docs/render-documentation,
                  https://hub.docker.com/r/t3docs/render-documentation/
:Docker tags:     https://hub.docker.com/r/t3docs/render-documentation/tags/
:Documentation:   Is being moved to https://github.com/t3docs/t3docs-documentation
                  and maintained separately
:Read more:       https://docs.typo3.org/typo3cms/RenderTYPO3DocumentationGuide/UsingDocker/
:See also:        Toolchain 'RenderDocumentation'
                  https://github.com/marble/Toolchain_RenderDocumentation
:Date:            2018-07-04
:Version:         Docker image version 'latest'='v1.6.11-full', from
                  repository branch 'master'
:Capabilites:     html, singlehtml, package, latex, pdf;
                  can read and convert ./doc/manual.sxw


Contribute
==========

Please use the `issue tracker
<https://github.com/t3docs/docker-render-documentation/issues>`__ for
contributing and reporting.


Quickstart on Linux
===================

Prepare Jenkins in Docker
-------------------------

1. Follow all steps mention in [a Install Docker](../README.rst#prepare-docker)

2. Copy all content of this directory (including all subdirectories) to a location on your docker host
    (e.g. /opt/docker/jenkins)
    
3. Change directory to dockerfiles

4. Build the Docker image

    execute buildDockerImage.sh

5. Create the Jenkins container

    execute dockerRun.sh
    
    Please do a restart of the Jenkins container after you finished its setup
    


Basic understanding
-------------------



-v "${BASE_DIR}"/external:/mnt/external \



      

Finally
=======

Enjoy!
