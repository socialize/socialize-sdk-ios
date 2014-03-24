.. include:: feedback_widget.rst

=================================================
Upgrading Socialize (CocoaPods and non-CocoaPods)
=================================================

Important Notes on Upgrading to v3.0.2
------------------------------------------------

Socialize 3.0.2 is compatible with iOS 7.1, which compiles for 64-bit devices by default. Since some dependent libraries have not yet been optimized for 64-bit devices, you may encounter build problems when compiling the Socialize SDK. To avoid 64-bit build errors, ensure your "Archtectures" settings in Xcode Build Settings for your project and targets are set as follows:

  .. image:: images/compiler_settings_302.png
        :width: 834
        :height: 193


Important Notes on Upgrading to v3.0.1
------------------------------------------------

As of 3.0.1, Socialize is available as a CocoaPod!

To upgrade from a non-CocoaPods install (pre-3.0.1) to a CocoaPods install, remove the old Socialize SDK per Step 2, below, then follow the directions in "Installing with CocoaPods" in the `Getting Started Guide`_. To upgrade a CocoaPods install, see below.
    .. _Getting Started Guide: getting_started.html


Important Notes on Upgrading to v2.8.9
--------------------------------------

For each of your application targets (or, if preferred, for the entire project), set the Debug setting of "Generate Test Coverage Files" and "Instrument Program Flow" in "Apple LLVM 5.0 - Code Generation" to "Yes":

  .. image:: images/compiler_settings_289.png
        :width: 529
        :height: 278


Important Notes on Upgrading to v2.4
------------------------------------

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


Upgrading with CocoaPods (v3.0.1 and Newer)
-------------------------------------------

If you already have a CocoaPods install of the SDK, future upgrades must also be done via CocoaPods. To do so, in the command line at the root directory of your project, enter the following:

::

            $ pod update


Upgrading via Framework (v3.0.0 and Older)
------------------------------------------

.. note:: This upgrade process can only be done for Socialize SDK installed via Framework; if you have installed via CocoaPods, you **must** upgrade with CocoaPods, as instructed above.
 
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

Step 2: Re-add the framework to your project
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
