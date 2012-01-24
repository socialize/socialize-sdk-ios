.. include:: feedback_widget.rst

=========================================
Enabling Push Notifications
=========================================

Introduction
----------------------------------------------------------------------

In v1.3 of Socialize we introduced push notifications. This provides your app with a simple and effective way to bring users back into the “viral loop” of the app.

.. image:: images/apns_screenshot.png


LiveAlerts in Comment Threads
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
when a user posts a comment they can elect to subscribe to updates for that topic.

When another user then posts a comment, the original user will receive a push notification to their device bringing them back into the app.



Step 1: Enable Notifications on the App Dashboard
--------------------------------------------------------------------------------
for Push Notifications to work they must be enabled on a compatible plan at http://getsocialize.com/apps

Select your app and click “Notification Settings”

.. image:: images/notification_web_settings.png

Then turn on enabled:

.. image:: images/notification_web_switch.png

Step 2: Configuring Your Apple App ID
--------------------------------------------------------------------------------
To enable APNS for your application you'll first have to configure your App ID in `Apple's developer portal <https://developer.apple.com/ios/manage/bundles/index.action>`.   
You can configure your App ID here:
https://developer.apple.com/ios/manage/bundles/index.action

.. image:: images/appid_listing.png


Step 3: Keys/Certificates for your App ID for APNS
--------------------------------------------------------------------------------
To start the process click the 'configure' button for your 'Production Push SSL Certificate' on the right hand side.  Follow the directions given to you by Apple **very carefully**.  Once you've completed the steps make sure you download the certificate and double-click on the certificate. 
This should result in the 'Keychain Access' application opening. 

.. note:: We currently don’t support development push certificates
.. note:: You don’t have to use your primary Keychain key as the identifier, nor does it have to connect to your developer account.   You can make a new keychain in Keychain Access, and use that to handle the Certificate Signing Request. This can be especially useful if you need to share this between multiple developers.

.. image:: images/add_certificates.png

Step 4: Exporting your .p12 (key/certificate pair) from the Keychain Access tool.
--------------------------------------------------------------------------------
After you've downloaded and double-clicked the certificate it should automatically open the 'Keychain Access' tool. Then find they 'My Certificates' category on the left hand side of the 
'Keychain Access' tool.  Right click on the 'Apple Production iOS Push Services' and export the key/certificate pair in the p12 (Personal Information Exchange) format.  
Save this file without a password and upload it to our developer portal.

.. image:: images/export_p12.png


Step 5: Uploading your .p12 to the Socialize Developer Portal
--------------------------------------------------------------------------------
To upload you'll need to get to the application dashboard: http://www.getsocialize.com/apps/ and select the application you want to configure.  If you've added a 
password to your p12 in the previous step make sure to put that in.

.. image:: images/notifications_edit_link.png



Step 6: Configuring Notifications in Your App
--------------------------------------------------------------------------------
To configure your app you'll need to register for notifications, handle the notification response and define an entity loader so we display users your content.

Register for Notifications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
You'll first need to register the application with the operating system to accept notifications

.. raw:: html

    <script src="https://gist.github.com/1671602.js?file=registerForNotifications.m"></script>

Register for Device Token
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
To configure Socialize inside the app, the minimum you'll need to do is register for notifications.  Run the application, and see that you get the push notification request pop-up. 
If you get an error, you might be using the wrong provisioning profile.

.. raw:: html

    <script src="https://gist.github.com/1566706.js?file=appDelegate.m"></script> 


Handle Notifications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Once a notification is received, you have to give Socialize the opportunity to handle it.
Our method call will let you know if the notification was a Socialize notification. This
allows you to use the logic below to also handle notifications of your own, if you need to.

.. raw:: html

    <script src="https://gist.github.com/1566706.js?file=MyAppDelegate.m"></script>


Defining an Entity Loader
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Some of Socialize's UI objects have the ability to link back to your application's objects.
We highly recommend that you register an "Entity Loader" block with Socialize. This is a piece
of code that is executed by Socialize when it wishes to display an entity. 

.. raw:: html

    <script src="https://gist.github.com/1667068.js?file=entityLoader.m"></script>

.. image:: images/entity_loader.png

.. note:: When building your application, keep in mind that notifications may be received on devices that do not yet have the entity available.  
