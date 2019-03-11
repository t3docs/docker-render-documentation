==========
Contribute
==========

Issues
======

Please use the `issue tracker
<https://github.com/t3docs/docker-render-documentation/issues>`__ to report issues.


Pull Requests
=============

You are welcome to submit pull requests to propose changes.

See `GitHub: Creating a pull request <https://help.github.com/articles/creating-a-pull-request/>`__
for information about creating a pull request.

Before submitting a pull request:

#. If it is not a minor change you may want to discuss this first: Use the Slack channel
   #typo3-documentation on https://typo3.slack.com (`register for Slack
   <https://my.typo3.org/index.php?id=35>`__ first) or create an `issue
   <https://github.com/t3docs/docker-render-documentation/issues>`__ for this.
#. If you make changes to the rendering, be sure to test this locally before submitting
   the pull request


Test Changes to Docker Image Locally
====================================

#. As usual, fork and clone the GitHub repository `t3dock/docker-render-documentation
   <https://github.com/t3docs/docker-render-documentation>`__
#. Enter the cloned repository::

      cd docker-render-documentation
#. As usual, create a branch::

      git checkout -b feature/xyz
#. You can build the docker image locally, using a different name::

      docker build -t render-documentation-local .

#. Now get a documentation project and use the locally built docker image,
   for example::

      git clone  https://github.com/TYPO3-Documentation/TYPO3CMS-Guide-ContributionWorkflow.git
      cd TYPO3CMS-Guide-ContributionWorkflow
      docker-compose run --rm html-local

The name/version used in the docker-compose.yml file must be the same one as used by
`docker build`. Here, we use the name **render-documentation-local**.

If your documentation project does not have a docker-compose.yml file for docker-compose
you can easily add one, see
`Quickstart with Docker Compose <https://github.com/t3docs/docker-render-documentation#quickstart-with-docker-compose>`__.

If you use the workflow with source / run and `dockrun_t3rd makehtml`, then once you
generated the documentation, you can
modify the file `Documentation-GENERATED-temp/last-docker-run-command-GENERATED.sh`
and replace the name / version of the Docker image with your locally built one and execute
this file to render the documentation with your locally built Docker image.
