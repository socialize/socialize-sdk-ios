.. include:: feedback_widget.rst

===============================
Advanced UI Configuration
===============================

Disabling Error Alerts
--------------------------------

If the error alert messages that the default Socialize UI objects emit do not fit your needs,
you can remove them using [Socialize storeUIErrorAlertsDisabled:YES].

In addition, a notification will be posted for all Socialize UI errors. The notification
will be posted regardless of whether or not you disable error alerts.

.. code-block:: objective-c

  - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
      [Socialize storeUIErrorAlertsDisabled:YES];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorNotification:) name:SocializeUIControllerDidFailWithErrorNotification object:nil];
      
      return YES;
  }

  - (void)errorNotification:(NSNotification*)notification {
      NSError *error = [[notification userInfo] objectForKey:SocializeUIControllerErrorUserInfoKey];
      NSLog(@"Error: %@", [error localizedDescription]);
  }

Automatic Third Party Linking
--------------------------------

v1.6.2 introduces Automatic Authentication for your users. Our data indicates
that users who authenticate with a 3rd party (e.g. Twitter or Facebook) are
much more likely to introduce new users to your app via the viral effect of
activity within your app propagating to these 3rd party networks. From v1.6.3
onwards the Socialize SDK will default to requiring users authenticate with a
3rd party prior to performing any social action (e.g. Comment or Like).

This default behavior can be overridden by the developer (you) with the
following settings:

.. code-block:: objective-c

  - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  ...
      // User can opt out of third party linking (default NO)
      [Socialize storeAnonymousAllowed:YES];

      // User is not shown third party link dialog on Social Actions (default NO)
      [Socialize storeAuthenticationNotRequired:YES];
  }
