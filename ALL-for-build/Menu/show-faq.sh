#!/bin/bash

# provide default
OUR_IMAGE=${OUR_IMAGE:-t3docs/renderdocumentation}
OUR_IMAGE_SHORT=${OUR_IMAGE_SHORT:-t3rd}

cat <<EOT

FAQ
===
Assume we are speaking of our container as '${OUR_IMAGE}' with
the shortname '${OUR_IMAGE_SHORT}'.

Q: What\'s the official repository?
A: https://github.com/t3docs/docker-render-documentation

Q: Where can I report problems?
A: https://github.com/t3docs/docker-render-documentation/issues

Q: Where can I find more information?
A: https://docs.typo3.org/typo3cms/RenderTYPO3DocumentationGuide/UsingDocker/

FAQ About GNU-Linux
-------------------
Q: What functions are defined (commandline)?
A: Type 'functions' as command.

Q: How can I see the definition of a function?
A: Type 'declare -f FUNCTIONNAME'

   For example:
      declare -f dockrun_${OUR_IMAGE_SHORT}
      declare -f dockbash_${OUR_IMAGE_SHORT}

FAQ about Docker
----------------
Q: How can I remove all untagged Docker images?
A: # list all images
   docker images

   # remove all untagged
   docker rmi --force \$(docker images | grep "^<none>" | awk '{print \$3}')


End of document.
EOT