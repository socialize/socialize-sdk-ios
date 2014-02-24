.. include:: feedback_widget.rst

===========================
Upgrade Notes: Socialize v2
===========================

Overview
------------------

This document highlights some of the major changes made in the second version
of the SDK, and how you can update your product to get the most out of
Socialize v2.

Basic Upgrade Process
------------------
For starters, this is your first time upgrading to a new Socialize release,
check out our `Upgrading Guide`_.
    .. _Upgrading Guide: upgrading.html

API Client Changes
------------------
Direct API calls are now block-based. In addition, most of the core API functionality
has been grouped into the utils classes. The utils classes with new API calls are:

- `SZEntityUtils <entities.html#working-with-entities>`_
- `SZUserUtils <users.html#working-with-users>`_
- `SZActionUtils <actions.html#working-with-actions>`_
- `SZShareUtils <sharing.html#working-with-shares>`_
- `SZCommentUtils <comments.html#working-with-comments>`_
- `SZLikeUtils <likes.html#working-with-likes>`_
- `SZViewUtils <views.html#views>`_

View Controller changes
-----------------------

The builtin view controllers are now packaged in simpler wrapper classes that
you should use instead. Typedefs have been added, and your old code should
continue to work. The new top-level controllers hide many underlying details
and have a simpler block-based interface for handling completion.

The full list of view controller changes:

- `SZUserSettingsViewController <users.html#user-profile>`_ has replaced SocializeProfileEditViewController
- `SZUserProfileViewController <users.html#user-settings>`_ has replaced SocializeProfileViewController
- `SZCommentsListViewController <comments.html#comments-list>`_ has replaced SocializeCommentsTableViewController
- `SZComposeCommentViewController <comments.html#comment-composer>`_ has replaced SocializeCommentsTableViewController

There is a new share dialog controller `SZShareDialogViewController <sharing.html#share-dialog>`_ which you can display directly.

Action Bar Changes
------------------

In addition, the action bar has been rewritten. Because the interface has
changed significantly, this is packaged as an entirely new class. You should
prefer the `SZActionBar <action_bar.html#displaying-the-action-bar>`_ instead of the SocializeActionBar. The major change in the way
the bar is used is that instead of having a view property, the bar is itself a view. You 
can read more about using the new action bar in the `Action Bar Section <action_bar.html>`_

.. literalinclude:: snippets/create_action_bar.m
  :start-after: begin-default-view-create-snippet
  :end-before: end-default-view-create-snippet
