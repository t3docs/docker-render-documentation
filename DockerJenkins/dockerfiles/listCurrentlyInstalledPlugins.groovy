/* go to for example localhost:8080/script and paste this script there to 
 get the currently installed list of plugins. paste the output to plugins.txt
 and rebuild image.
*/
def plugins = jenkins.model.Jenkins.instance.getPluginManager().getPlugins()
plugins.each {println "${it.getShortName()}:${it.getVersion()}"}

