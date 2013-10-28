.. include:: feedback_widget.rst

=====================
Upgrading Socialize
=====================

Important Notes on Upgrading to v2.8.9
-----------------

For each of your application targets (or, if preferred, for the entire project), set the Debug setting of "Generate Test Coverage Files" and "Instrument Program Flow" in "Apple LLVM 5.0 - Code Generation" to "Yes":

  .. image:: images/compiler_settings_289.png
        :width: 529
        :height: 278

Important Notes on Upgrading to v2.4
-----------------

Entity loader events that occur when Socialize does not have a preexisting
navigation controller on the screen no longer automatically push a new
UINavigationController. This was made the default since the old behavior was
intrusive for apps that might not want to display a navigation controller at
all for this case. The UINavigationController parameter of the entity loader is
now passed as nil, and it is left up to you to choose how to handle this
situation.

.. literalinclude:: snippets/configure_notifications.m
  :start-after: begin-entity-loader-snippet
  :end-before: end-entity-loader-snippet
  :emphasize-lines: 14-25

Overview
------------------

This document highlights the process you should use for updating your project to use a new
Socialize iOS SDK release.
 
Step 1: Download a new release
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- **Download and unzip an iOS SDK release from the website.**  
  Release can be found here: https://github.com/socialize/socialize-sdk-ios/downloads

Step 2: Delete the Old Socialize Framework from your Project
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- **Remove the existing embedded static framework and resources from your application.**

  Assuming resources are unmodified, the simplest thing to do is to just delete
  all resources and readd them.

.. image:: images/delete_framework.png

- **Ensure that the Socialize.embeddedframework folder is also removed from
  disk. Xcode may leave the empty Socialize.embeddedframework
  directory around. This could cause a copy error in the next step.**

Step 2: Readd the framework to your project
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- **Install the embedded static framework to your application.**

  To do this just drag and drop Socialize.embeddedframework folder from the
  package to your framework section in your project.

.. note:: Be sure to drag the outlying .embeddedframework folder, not just the
  framework. The .embeddedframework directory contains both the Socialize
  framework and the Socialize resources.  If you just add the framework, you will
  be missing important Socialize images and configuration files.

.. image:: images/drag_and_drop.png

- **When prompted, check "Copy items into destination group's folder (if needed)" and click finish**

 	.. image:: images/check_copy_items.png

.. note:: If you get errors when copying files, ensure that the Socialize.embeddedframework
  folder has been removed from the filesystem (using finder or terminal). If it still there,
  delete it before performing this step
