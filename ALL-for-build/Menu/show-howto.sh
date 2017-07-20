#!/bin/bash

# provide default
OUR_IMAGE=${OUR_IMAGE:-t3docs/render-documentation}
OUR_IMAGE_SHORT=${OUR_IMAGE_SHORT:-t3rd}

cat <<EOT
==================================================
Howto
--------------------------------------------------

Experts: Quickstart for the impatient
=====================================

Prepare:

   docker pull t3docs/render-documentation
   source <(docker run --rm t3docs/renderdocumentation show-shell-commands)

Render:

   cd PROJECT
   dockrun_${OUR_IMAGE_SHORT} makehtml


Everybody: Get started
======================

Verify your Docker is working:

   docker run --rm hello-world


Get a project with documentation:

   # fetch a sample project as PROJECT
   git clone https://github.com/T3DocumentationStarter/Public-Info-000 \\
             PROJECT

   # go to PROJECT
   cd PROJECT


Get the Docker image:

   By download:

      docker pull ${OUR_IMAGE}

   Or build it yourself:

      git clone https://github.com/t3docs/docker-render-documentation \\
                t3docs/docker-render-documentation

      cd t3docs/docker-render-documentation
      docker build -t ${OUR_IMAGE} .


Run the Docker image:

   docker run --rm ${OUR_IMAGE}
   docker run --rm ${OUR_IMAGE} --help
   docker run --rm ${OUR_IMAGE} show-faq
   ...


Render your documentation:

   cd PROJECT
   mkdir Documentation-GENERATED-temp 2>/dev/null
   docker run --rm \\
      -v "\$PWD":/PROJECT/:ro \\
      -v "\$PWD"/Documentation-GENERATED-temp/:/RESULT/ \\
      --user=\$(stat \$PWD --format="%u:%g") \\
      $OUR_IMAGE makehtml


Create handy shortcuts for the commandline:

   In several steps:

      docker run --rm ${OUR_IMAGE} show-shell-commands > temp
      source temp
      rm temp

   In just one step:

      # attention: no blanks between '<('
      source <(docker run --rm ${OUR_IMAGE} show-shell-commands)

   Now THIS terminal window has a new command (=function) on the commandline:

      dockrun_${OUR_IMAGE_SHORT}
      dockrun_${OUR_IMAGE_SHORT} --help
      ...

Use the new command to render the documentation:

   cd PROJECT
   dockrun_${OUR_IMAGE_SHORT} makehtml

Use the new command in general:

   dockrun_$OUR_IMAGE_SHORT
   dockrun_$OUR_IMAGE_SHORT --help
   dockrun_$OUR_IMAGE_SHORT show-faq
   dockrun_$OUR_IMAGE_SHORT show-howto
   dockrun_$OUR_IMAGE_SHORT tct --help
   ...

If you did create the shortcuts there should be another one as well.
It takes you to the shell of your container:

   dockbash_$OUR_IMAGE_SHORT

To find out what it means in expanded form type:

   dockrun_$OUR_IMAGE_SHORT show-shell-commands



Developers
==========

Fetch a suitable project that has a read-write folder structure /ALL:

   git clone  https://github.com/t3docs/docker-render-documentation \\
              t3docs/docker-render-documentation

   # go to the project
   cd t3docs/docker-render-documentation


Required and possible volume mappings:

    Host      Container     :ro  Type      Comment
    ========= ============= ===  ========= =======
    PROJECT/  /PROJECT/:ro  yes  required  Read only. The project that has documentation/
    1)        /RESULT/      no   required  Read-write output folder for the result.
    2)        /ALL/         no   optional  For development
    tmp/      /tmp/         no   optional  To find out about the created tmp data.

    1) = PROJECT/Documentation-GENERATED-temp/
    2) = ALL-for-RW-mount   (provide files yourself)


    ===================
    ATTENTION & WARNING
    ===================
    Be sure to map the correct folder to /RESULT/.
    It's content will totally be overwritten!
    Don't accidentally mount all your harddrive.


Fetch the docker image (= our executable):

   docker pull t3docs/render-documentation

Run the container in developer mode.
Look for `devdockrun_$OUR_IMAGE_SHORT` and `devdockbash_$OUR_IMAGE_SHORT`
in the shell commands:

   dockrun_$OUR_IMAGE_SHORT show-shell-commands


==================================================
Finally
--------------------------------------------------

Have fun!
EOT
