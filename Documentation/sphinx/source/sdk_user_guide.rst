.. include:: feedback_widget.rst

=============================================
SDK User Guide
=============================================

Introduction
------------
The Socialize SDK provides a simple set of classes and methods built upon the `Socialize REST API <http://www.getsocialize.com/docs/v1/>`_

App developers can elect to use either the pre-defined user interface controls provided in the Socialize UI 
framework, or "roll their own" using direct SDK calls.

ALL calls to the Socialize SDK are *asynchronous*, meaning that your application will not "block" while 
waiting for a response from the Socialize server.

You are notified of the outcome of calls to the Socialize service via a *SocializeServiceDelegate* 
passed into each call to the Socialize SDK.

The main class through which you will be interacting would be Socialize. You can authenticate, comment, like/unlike via Socialize instance and are detailed in the following section.

Initializing Socialize
----------------------

To start using the SDK. You need to create and initialize Socialize class and implement the SocializeServiceDelegate.

.. raw:: html

	<script src="https://gist.github.com/1204490.js?file=Init.m"></script>

Authentication
--------------
Every call against the Socialize SDK MUST be authenticated.  

On the first successful call to "authenticate" the credentials are automatically cached in the 
application so subsequent calls are much faster.

Authenticating with Facebook
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
We recommend authenticating with 3rd parties (e.g. Facebook) as this provides a better user experience 
and ensures that user profiles and IDs are retained across app sessions and installs.  

There are 2 variants to achieve the same result. If you already have authenticated with facebook then you can pass the facebook access token to SocializeSDK or you can have the SocializeSDK perform facebook authentication for you.


.. raw:: html

	<script src="https://gist.github.com/1370829.js?file=FacebookAuthentication.m"></script>
	
Authenticating with Twitter
~~~~~~~~~~~~~~~~~~~~~~~~~~~
*Coming Soon!*
	
Anonymous Authentication
~~~~~~~~~~~~~~~~~~~~~~~~
We recommend authenticating with 3rd parties (e.g. Facebook) as this provides a better user experience 
and ensures that user profiles and IDs are retained across app sessions and installs, however if you just 
want anonymous authentication, simply call the **authenticate** method:

.. raw:: html

        <script src="https://gist.github.com/1229170.js?file=Authentication.m"></script>
	
Entities
--------
An entity is a single item of content in your app

Throughout the documentation and the code snippets we refer to an "entity".  This is simply a 
generic term for something that can be view, shared, liked or commented on.  Generally this will
correspond to a single item of content in your app.

Entity keys in Socialize are free form.  It is recommended that a *real* URL be
used (i.e. one that corresponds to an active web page)

Creating an Entity
~~~~~~~~~~~~~~~~~~
An entity consists of a **key** and a **name**.  The name should be descriptive and help you identify the 
entity when viewing reports on the Socialize dashboard.

Creating an entity explicitly in this manner is **optional but recommended**.
If you simply post a comment,view,share or like against an entity key that does
not currently exist, it will be automatically created for you, but will not
have a *name* associated with it.

To create an entity, simply invoke the **createEntity** message:

.. raw:: html

    <script src="https://gist.github.com/1473477.js?file=CreateEntity.m"></script>

Entity Meta Data, and Other Advanced Functionality
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Should you find that you need to store custom metadata on an entity, Socialize
will provide for this. Full customization of entity objects can be realized
through use of the createEntity: variant for creating your entity.

.. raw:: html

    <script src="https://gist.github.com/1719630.js?file=createEntity.m"></script>

Retrieving Entity data
~~~~~~~~~~~~~~~~~~~~~~
An existing entity can be retrieved via the **getEntity** method.  Entities obtained in this way will also 
provide aggregate data on comments, likes, shares and views.  Refer to the `Entity object structure in the API Docs <http://www.getsocialize.com/docs/v1/#entity-object>`_.
for more detail on these aggregate values.

.. raw:: html

	<script src="https://gist.github.com/1204768.js?file=GetEntity.m"></script>


View
----
A 'view' is simply an event that records when a user views an entity.  Views are reported on the Socialize 
dashboard and provide an excellent way for you to determine which content items in your app are getting the 
most interest.

Creating a 'View'
~~~~~~~~~~~~~~~~~
To create a view, simply call the **viewEntity** method:

.. raw:: html

	<script src="https://gist.github.com/1204490.js?file=PostAView.m"></script>

Like
----
A 'like' represents a user's vote for an entity.  Likes are a way for you to determine which content items 
in your app are the most popular, and what is of most interest to your users.

Creating a 'Like'
~~~~~~~~~~~~~~~~~
To create a view, simply call the **like** method:

.. raw:: html

	<script src="https://gist.github.com/1204490.js?file=PostLike.m"></script>
	
Removing a 'Like'
~~~~~~~~~~~~~~~~~
Removing a like (i.e. an 'unlike') is done via the **unlike** method.  In order to remove a like, you will 
need the ID of the like.  This is returned from the initial call to **like**

.. raw:: html

	<script src="https://gist.github.com/1204490.js?file=Unlike.m"></script>

Comment
-------
Comments are a great way to build engagement in your app, and users love making comments!

Creating a Comment
~~~~~~~~~~~~~~~~~~
To create a comment on an entity, use the **createCommentForEntityWithKey:::** method:

.. raw:: html

	<script src="https://gist.github.com/1204490.js?file=Comment.m"></script>

Listing Comments
~~~~~~~~~~~~~~~~
To list all comments for an entity use the **getCommentList** method. 

.. raw:: html

	<script src="https://gist.github.com/1204490.js?file=GetComments.m"></script>

Share
-----
To register a share with the Socialize servers, use the **createShareForEntityWithKey:medium:text:** method.

.. raw:: html

    <script src="https://gist.github.com/1436022.js?file=CreateShare.m"></script>

