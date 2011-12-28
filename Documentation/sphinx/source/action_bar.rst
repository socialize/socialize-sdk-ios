.. include:: feedback_widget.rst

=========================================
Socialize Action Bar
=========================================

Introduction
------------

v0.5.0 of the Socialize SDK introduced the "Action Bar" which provides a single
entry point into the entire set of Socialize features.

Displaying the Action Bar
-------------------------

Using the SocializeActionBar is very simple. Instantiate a SocializeActionBar controller and add the view to your view controller:

.. raw:: html

        <script src="https://gist.github.com/1474007.js"> </script>

By default, the Action Bar will automatically place itself at the bottom of its
superview and adjust to rotation.  If you find that content is being hidden,
one option is to ensure that 44 pixels are left empty at the bottom of your
view. When using interface builder, this is as simple as sliding up the bottom
of any content.

Advanced Layout Configuration
-----------------------------

*Optional Configuration with no Automatic Layout*

If you  find you have problems with the Action Bar Automatic Layout, and you
would like to disable the auto layout feature completely, you can do so. The
following example disables autolayout and manually places the Action Bar at
(0,400).

.. raw:: html

        <script src="https://gist.github.com/1474011.js"> </script>

If you need more detail on installing the action bar please see our `Adding the Socialize Action Bar Video`_.

    .. _Adding the Socialize Action Bar Video: http://vimeo.com/31403049

Delegate
--------

Defining a SocializeActionBarDelegate will allow you to customize some behavior of the
action bar.

Showing Action Sheets
~~~~~~~~~~~~~~~~~~~~~

If you wish, you can customize the way the Action Bar shows action sheets. To do this,
just implement actionBar:wantsDisplayActionSheet:, as below

.. raw:: html

      <script src="https://gist.github.com/1528996.js"> </script>

More Info
-----------------------

If you need more detail on installing the action bar please see our `Adding the Socialize Action Bar Video`_.

    .. _Adding the Socialize Action Bar Video: http://vimeo.com/31403049


