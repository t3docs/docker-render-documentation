#!/bin/bash

# provide default
OUR_IMAGE=${OUR_IMAGE:-t3docs/renderdocumentation}
OUR_IMAGE_SHORT=${OUR_IMAGE_SHORT:-t3rd}
OUR_IMAGE_SLOGAN=${OUR_IMAGE_SLOGAN:-t3rd_TYPO3_render_documentation}

cat <<EOT

FAQ
===
Assume we are speaking of our container as '${OUR_IMAGE}' with
the shortname '${OUR_IMAGE_SHORT}'.

Q: What does '${OUR_IMAGE_SHORT}' mean?
A: '${OUR_IMAGE_SLOGAN}'

Q: What is the official repository?
A: https://github.com/t3docs/docker-render-documentation

Q: Where can I report problems?
A: https://github.com/t3docs/docker-render-documentation/issues

Q: Where can I find more documentation?
A: https://docs.typo3.org/typo3cms/RenderTYPO3DocumentationGuide/UsingDocker/


FAQ About GNU-Linux
-------------------
Q: What functions are defined (commandline)?
A: Type 'functions' as command.

Q: How can I see the definition of a function?
A: Type 'declare -f FUNCTIONNAME'

   For example:
      declare -f ${DOCKRUN_PREFIX}${OUR_IMAGE_SHORT}


FAQ about Docker
----------------
Q: How can I remove all untagged Docker images?
A: # list all images
   docker images

   # remove all untagged
   docker rmi --force \$(docker images | grep "^<none>" | awk '{print \$3}')

Q: How can I remove unused data volumes?
A: # list volumes
   docker volume ls
   docker volume ls --filter dangling=true

   # remove all unused
   docker volume prune


End of document.
EOT