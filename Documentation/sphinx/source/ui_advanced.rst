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

.. raw:: html

  <script src="https://gist.github.com/2008558.js?file=errorNotifications.m"></script>
