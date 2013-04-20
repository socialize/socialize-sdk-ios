.. include:: feedback_widget.rst

=========================================
Frequently Asked Questions
=========================================

How can i determine the version of Socialize I am using?
--------------------------------------------------------
Use +[Socialize socializeVersion]

How can i change the text that is shared to Twitter or Facebook?
----------------------------------------------------------------
See the :ref:`custom_share_dialog` 

Project will not build, missing symbols
---------------------------------------
Most missing symbol errors are caused by a missing framework.
You should check that you are linking with all of the required frameworks.
You can also try googling for the missing symbol names to see if they are a part
of an apple-provided framework.

SDK Crashes on startup
----------------------
The most common cause of this is missing Socialize Resources. Please ensure you've
dragged the entire Socialize.embeddedframework directory into your project. This should
include the Resources directory. Please check that SocializeConfigurationInfo.plist shows
up in the "Copy Bundle Resources" of your target's Build Phases

SDK download size footprint
---------------------------
The Socialize SDK and its resources will add about 1.75MB to your project.
