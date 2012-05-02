.. include:: feedback_widget.rst

=========================================
Socialize Comments
=========================================

Comment View
----------------------
v0.4.0 of the Socialize SDK introduced the "Comment View" which provides the creation and viewing 
of comments associated with an entity (URL).  

.. image:: images/comment_list.png	
.. image:: images/new_comment.png	
.. image:: images/comment_detail.png	

Displaying the Comment View
~~~~~~~~~~~~~~~~~~~~~~~~~~~

When you want to launch the comment view, simply instantiate and present the commentViewController :

.. code-block:: objective-c

  - (IBAction)commentsButtonPressed {
      //create an entity that is unique with your application.
      NSString *entityUrlString = @"http://www.example.com/object/1234";
      
      UIViewController *commentsController = [SocializeCommentsTableViewController socializeCommentsTableViewControllerForEntity:entityUrlString];
      [self presentModalViewController:commentsController animated:YES];
  }
