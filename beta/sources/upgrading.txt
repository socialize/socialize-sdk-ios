.. include:: feedback_widget.rst

=====================
Upgrading Socialize
=====================

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
