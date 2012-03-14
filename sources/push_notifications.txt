.. include:: feedback_widget.rst

=========================================
Enabling SmartAlerts™ Notifications
=========================================

Introduction
----------------------------------------------------------------------

In v1.3 of Socialize we introduced push notifications. This provides your app with a simple and effective way to bring users back into the “viral loop” of the app.

.. image:: images/apns_screenshot.png


SmartAlerts™ in Comment Threads
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
when a user posts a comment they can elect to subscribe to updates for that topic.

When another user then posts a comment, the original user will receive a push notification to their device bringing them back into the app.



Step 1: Setup SmartAlerts™ on the App Dashboard
--------------------------------------------------------------------------------
for Push Notifications to work they must be enabled on a compatible plan at http://getsocialize.com/apps

Select your app and click “SmartAlerts Settings”

.. image:: images/notification_web_settings.png

Then turn on enabled:

.. image:: images/notification_web_switch.png

Step 2: Configuring Your Apple App ID
--------------------------------------------------------------------------------

Find your App ID in the `Apple's developer portal <https://developer.apple.com/ios/manage/bundles/index.action>`_ here: https://developer.apple.com/ios/manage/bundles/index.action> . Then click 'Configure' on the right-hand side.

.. image:: images/appid_listing.png

Make sure "Enable for Apple Push Notification service" is checked.

Step 3: Keys/Certificates for your App ID for APNS
--------------------------------------------------------------------------------

* Click the 'configure' button for your 'Production Push SSL Certificate' on the right hand side.  
Follow the directions given to you by Apple **very carefully**.  

.. note:: 

    * We currently don’t support development push certificates
    * You don’t have to use your primary Keychain key as the identifier, nor does it have to connect to your developer account.   You can make a new keychain in Keychain Access, and use that to handle the Certificate Signing Request. This can be especially useful if you need to share this between multiple developers.

.. image:: images/add_certificates.png

 
* Open the certificate after completing the steps and downloading the certificate(.cer) by double clicking the file.  This should result in the 'Keychain Access' application opening.  

* **Re-create your distribution provisioning profile, download and re-install the profile**.

.. note:: 

    It is important to note that just creating or updating your Apple Push Notification Service certificate will not update your provisioning profile.  Therefore make sure to re-create your distribution
    provisioning profile for your changes to take effect.
 
Step 4: Exporting your .p12 (key/certificate pair) from the Keychain Access tool.
----------------------------------------------------------------------------------------

Double-clicking the certificate(.cer) should automatically open the 'Keychain Access' tool. 

* Find the 'My Certificates' category on the left hand side of the 'Keychain Access' tool. 

* Right-click on the 'Apple Production iOS Push Services' and export the key/certificate pair in the p12 (Personal Information Exchange) format.  

* Save this file without a password to your desktop.
  

.. image:: images/export_p12.png


Step 5: Uploading your .p12 to the Socialize Developer Portal
--------------------------------------------------------------------------------

* Go to your SmartAlert's setup dashboard and upload the p12 from the previous step.  You can find your application dashboard here: http://www.getsocialize.com/apps

If you've added a password to your p12 make sure to put that in.

.. image:: images/notification_p12_upload.png




Step 6: Configuring Notifications in Your App
--------------------------------------------------------------------------------
To configure your app you'll need to register for notifications, handle the notification response and define an entity loader so we display users your content.

Register for Notifications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Add the following line to your application delegate:

.. raw:: html

    <script src="https://gist.github.com/1671602.js?file=registerForNotifications.m"></script>

Register the Device Token
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
To register your app's device token add the following lines to your application's delegate

.. raw:: html

    <script src="https://gist.github.com/1566706.js?file=appDelegate.m"></script> 

Handle Notifications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* Add the lines below to allow Socialize to handle the notification.


.. raw:: html

    <script src="https://gist.github.com/1566706.js?file=MyAppDelegate.m"></script>

.. note::

    * Socialize will not currently do any foreground handling of notifications. If a notification is received while the Application is in the foreground, it will be ignored.
    * Our method call will let you know if the notification was a Socialize notification. This allows you to use the logic below to also handle notifications of your own, if you need to.
 
Defining an Entity Loader
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
For Smart Alerts to work correctly, you must define an entity loader.

Defining an Entity Loader allows Socialize's UI objects to link back to your
application's objects.

Copy the lines below to add an entity loader 

.. raw:: html

    <script src="https://gist.github.com/1667068.js?file=entityLoader.m"></script>

.. image:: images/entity_loader.png

For some applications, it might happen that an entities are not always
available. Socialize provides the ability to selectively disable loading for a
given entity. Should you find you need this, you can do this by defining a "Can
Load Entity" block, as follows

.. raw:: html

    <script src="https://gist.github.com/1667068.js?file=canLoadEntity.m"></script>

Testing SmartAlerts™ 
-----------------------------------------------------------------------------------

In order to test that SmartAlerts™ are working correctly you'll want to first to get your app compiled and installed on a physical device and working 
on the simulator as well.  

#. Open apps on both the simulator and the physical device.
#. From the physical device leave a comment on an entity.  Make sure you to subscribe to entity when you leave a comment.  You should now be subscribed to the entity and will receive notifications when someone else leaves a comment.
#. On the simulator add a comment to the same the entity from which you did on the physical device.
#. Notifications are sent out asynchronously in a queue.  It may take 2-3 minutes to receive your notification.

.. image:: images/subscribe_button.png

.. note:: The subscribe button will only show on an actual device. If you do not see the button on the device, please refer to the Troubleshooting section below.

Troubleshooting Notifications
----------------------------------------

If you are not receiving notifications, there are some simple ways to troubleshoot problems.  We also have a vibrant developer community and support 
here: http://support.getsocialize.com support who can help Additionally here some common errors you might encounter


I Don't See the Notifications Button
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The notifications button will only appear if a valid push token has been
registered with Socialize using [Socialize registerDeviceToken:]. This means
the buttons will never show on the iOS simulator.

If you do not see the buttons on the actual device, you might try making sure there
are no errors with registration process, as described in the next section.

Logging Errors from Notifications Registrations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can implement the notifications delegate method which callbacks if any error occurs during registration.  This should log
the value of the error to your console.

.. raw:: html

    <script src="https://gist.github.com/1671602.js?file=HandleError.m"></script>


I Keep Getting the Error "no valid 'aps-environment' entitlement string found for application"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This typically means you didn't re-create and download the provisioning profile after you enabled pushed notifications.  
You can re-create your distribution profile here: https://developer.apple.com/ios/manage/provisioningprofiles/viewDistributionProfiles.action.  You'll also want to remove any 
other versions of provisioning file which exist on your phone.

Everything looks ok, but I am still not receiving notifications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

One possibility is that Socialize has received a development push token.
Development tokens will currently prevent pushes being sent to real devices.
Until Socialize automatically clears these on error, you should verify that you
do not send development tokens to Socialize using [Socialize
registerDeviceToken:]

As a precaution, you might wrap the registration call as follows:

.. raw:: html

  <script src="https://gist.github.com/1879369.js?file=gistfile1.m"></script>

This is only a problem if you already have separate push configurations and certificates
for development and distribution. Socialize itself does not support development push.

Please go to support.getsocialize.com for additional support.
