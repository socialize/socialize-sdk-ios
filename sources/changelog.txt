.. include:: feedback_widget.rst

=============================================
Changelog
=============================================

v1.5
----
[feature] Add canLoadEntity block to disallow loading of specific entities [ ui]

[feature] Developer can authenticate user with twitter in SDK [ twitter auth ]

[feature] User can sign in to Twitter from UI [ twitter]

[feature] User can sign out of facebook [ facebook auth ui]

[feature] Socialize 401 error should automatically wipe local credentials for default UI controls [ ]

[feature] Developer can link to multiple third parties via /authenticate/ [ ]

[feature] Add develop device token notes to trouble shooting section of ios SDK docs [ documentation ]

[feature] User can share via twitter on share window [ twitter share ]

[bug] Facebook default perms now include offline_access [ facebook]

[feature] Likes autotweet if enabled [ twitter ]

[feature] User can enable/disable auto-tweeting of likes and comments in settings [ ui twitter]

[feature] Comments autotweet if enabled [ twitter ui]

[bug] Fix a case where empty comment still allowed [ ui]

[feature] Third parties always show on comment controller [ ui]

[feature] Third party auth flow goes directly to settings instead of profile [ ui auth]

v1.3.5
------
[bug] Fix SocializeRequest crash [ ]

[bug] NSDate hexString category method has same name as apple private API [ ]

[feature] Developer can silence Socialize UI error messages [ ]

[feature] Errors in Socialize UI should post notification [ ]

[feature] Enable search box in docs [ ]

v1.3.4
------
[bug] Remove all caching of device tokens [ notifications]

v1.3.3
------
[bug] Update documentation to make it clear that entity loader is required for notifications [ documentation notifications]

[bug] Clean up token send logic and add better logging [ notifications]

v1.3.2
------
[bug] App will crash if external Facebook auth is used, but no app id defined with Socialize [ crash facebook ]

[bug] Displaying PostComment before being authenticated causes 400 error [ authentication ]

v1.3.1
------

[bug] Changing app's location authorized status should immediately update UI controls [ ]

[feature] add debug level warning that facebook isn't configured. [ ]

[bug] "no comments to show" message should hide after first comment [ ]

[bug] "Add Comment" at bottom of comments list not justified when notifications button hidden [ ]

[bug] storeSocializeApiKey:andSecret: needs to be deprecated/renamed [ ]

[feature] add SMS to Sharing [ ]

[feature] Allow specifying entity name when creating action bar [ ]

[feature] Allow navigation to settings from activity detail [ ]

[feature] add description of an "entity key" in documentation - get this from the android doco [ ]

[bug] make sure to strip blank space from key/secret before sending it to server [ ]

v1.3
----

[feature] Socialize Smart Alerts (push notifications on iOS) [ ]

[feature] add a block callback to handle entity loading. [ ]

[bug] Setting url scheme suffix should not be required (currently crashes on assertion) for users fb authing on their own [ ]

[feature] Likes should post to Facebook [ ]

[feature] Add a generic Action Detail view for comment info

[feature] Facebook wall content urls for app and entity now use indirect getsocialize.com links instead of direct links [ ]

v1.1.9
------
[bug] Fix setDelegate warning on _Socialize.h when using ARC [ ]

[bug] Paginated view would hit server on scroll of empty view [ ]

[bug] Dismiss action bar mail composer would increment view count [ ] 

v1.1.8
------
[bug] fix the final package to not follow symlinks and reduce the total package size. [ ]

[bug] MFMailComposeDelegate crashes on nil modal display attempt when no email clients are configured. [ ]

v1.1.7
------
[bug] when FB is not configured the authentication screen still shows [ ]

[bug] canceling FB when authenticating causes anonymous data to be removed, resulting in a new anonymous user [ ]

[bug] Profile View still show facebook details after removeAuthenticationInfo. [ ]

[bug] Username label in comment details is too small [ ]

[bug] Fix Profile and Comments List view layout on iPad [ ]

[bug] Profile and Comments List do not paginate correctly on iPad [ ]

[bug] ActionBar should use showFromTabBar: for action sheet display when target is a UITabBarController [ ]

[feature] Add ActionBar delegate callback for custom action sheet display behavior [ ]

v1.1.6
------
[bug] User's own profile image does not update in activity after changing profile image [ ]

[bug] Large profile images fail to send to server [ ]

[bug] Profile edit right side button being called "save" before edit is confusing [ ]

[bug] Crash can occur after certain profile edits [ ]

[bug] Fix some bugs that occur when editing profile a second time [ ]

[bug] Changing profile image to a large image causes noticeable main thread block with no indication [ ]

v1.1.5
------
[feature] Remove requirement for URL from code and docs [ ]

[bug] Fixed some minor bugs found by static analyzer [ ]

[bug] Fix memory leaks [ ]

v1.1.4
------
[bug] Editing only profile image does not update server [ regression ]

[bug] Pressing share on pre-5.0 iPad causes crash [ ]

[bug] Socialize Navigation Bar background cut off on iPad [ ]

[bug] Fix some circular references in action sheet block callbacks [ ]

v1.1.3
------
[feature] Facebook errors presented to user (e.g. "Wall post failed") are more detailed [ ]

[bug] Docs "My App Already Uses Facebook" section missing a step [ ]

[bug] Facebook section shows up twice in docs [ ]

[feature] Socialize errors presented to user (e.g. 400) are more specific [ ]

[bug] Facebook wall post success should not be required for create comment [ ]

[bug] Facebook button does not adjust properly for landscape [ ]

[bug] Share subsection in the docs "SDK User Guide" section out of date [ ]

[feature] Improve getting started guide [ ]

v1.1.2
------

[bug] Posting a new comment from comments list should update the comments list [ ] 

[bug] Reopening comments list should refresh content [ ] 

[bug] Action Bar Buttons should not be visible during initial load [ ] 

[bug] Post Share's send button should still be disabled after a new facebook auth [ ] 

[bug] If paginated view quickly hidden and shown during initial content load, first page is requested twice [ ] 

[bug] On second edit profile from action bar, save button is not reenabled [ ] 

[bug] Remove some lingering NSLog messages [ ]

v1.1.1
------

[feature] documentation should have a more complete getting started guide [ ] 

[bug] UIBarButtonItem memory leaks [ ] 

[bug] fix shouldAutoRotateToInterfaceOrientation: for message composition views [ ]



v1.0.0
------

[feature] make profile clickable in the comment detail view 

[bug] Profile edit value nav buttons still hiding on 4.3 

[chore] hide the activity view on profile view controller 

[feature] Authorizing drops user into directly into edit profile (instead of profile) to make some settings more obvious

v0.10.1
-------

[feature] Create new getting started video based on new documentation [ ] 

[feature] List activity for User SDK [ ] 

[feature] Create an entity share for SDK [ ] 

[feature] Share via email [ ] 

[feature] add landscape support for commenting/action bar [ ] 

[feature] Add share to Action Bar [ ui ] 

[feature] Add call to facebook graph API [ ] 

[feature] Comments/likes should post to FB [ ] 

[feature] Add user preferences for auto-posting comments/likes [ ] 

[feature] Create UDID replacement algorithm [ ] 

[bug] Fix button on action bar [ ] 

[feature] LIkes should post to FB [ ] 

[bug] when you clean out auth and then go to the profile view controller sample app [ crash] 

[bug] Socialize auth conflicts with users pre-authorizing facebook [ ] 

[bug] Loading mode disabled too early in text composition views [ regression] 

[feature] ActionBar should not hide any content [ ] 

[bug] navigation buttons for UIViewControllers on simulator 4.3 don't show up [ ] 

[feature] make profile clickable in the comment detail view [ ] 

[feature] add custom FB authentication dialog from AppMakr [ ] 

[feature] Add "post to facebook" switch to PostCommentViewController [ ]

v0.9.0
------

[feature] add documentation for adding FB ID to the code [ ] 

[feature] add branding to the top of the navigation bar [ ] 

[feature] Action bar should auto increment view [ ] 

[bug] Action bar buttons cannot be pressed [ ] 

[bug] PostCommentViewController does not dismiss self after facebook profile view on iOS5 [ ] 

[bug] ActionBar comment count not updating after post [ ] 

[feature] add documentation for Action Bar [ ] 

[feature] An End User should be able to view another users profile [ ] 

[bug] SocializeActionBar should require parent view controller [ ]

v0.8.0
------

[feature] Add like service support to the action bar [ ] 

[feature] remove the second dialog when adding a comment [ ] 

[bug] Fix issues in the SDK and Sample Sdk App which were found by static analyzer. [ ] 

[feature] Add GetSatisfaction widget to documentation [ ] 

[bug] App Crashes if facebook id not defined [ ] 

[bug] Update documentation on presenting SocializeCommentsTableViewController [ ] 

[feature] Re-add posting of profile image once PUTs are fixed [ ] 

[feature] Facebook auth hardening (assertions) and documentation updates [ ] 

[feature] Our SocializeActionBarView should work similar to existing Ad SDKS like Admob [ ]

v0.7.1
------

[bug] Release configuration contains incorrect url [ ]

v0.7.0
------

[feature] upgrade to iOS5 [ ] 

[bug] remove alert when user pushes 'cancel' on comment entry box. [ ] 

[bug] Find and fix memory allocation issues in the Sample Application. [ ] 

[bug] Find and fix memory allocation issues in the Socialize SDK [ ] 

[feature] apply the existing the UI Profile view from AppMakr [ ] 

[feature] User edit UI actually edits the user's profile [ ] 

[feature] Edit User(Profile) SDK [ ] 

[feature] Socialize action bar [ ui ] 

[bug] remove gcov dependency [ ] 

[bug] UI bug when rendering UICommentsViewController [ ui ] 

[bug] navbar header image in iOS5 don't show [ ] 

[feature] exposed viewcontrollers should provide their own navigation controller since we'll ask users to present us a modal. [ ] 

[bug] Buttons get hidden when using ios4.3 simulator and navigating back and forth [ ]

0.6.0
-----

[feature] User can authenticate with Facebook [ i-test needed ] 

[bug] the embedded framework package zip doesn't work because of missing header files [ ] 

[bug] rename SBJSON library from FB to have the socialize prefix [ ] 

[feature] remove alert from comment list view when getting comments for an entity if the entity doesn't exist. [ ] 

[feature] provide better error log messages for raw response method [ ] 

[feature] UI Views should automatically authenticate [ ] 

[feature] Get User (Profile) SDK [ ] 

[feature] User profile view [ ui ] 

[bug] fix embedded framework to include the right headers [ ]


0.1.0
-----

[feature] Unlike an entity [ ]

[feature] All API calls must be authenticated using the /authenticate API [ ]

[feature] Like an entity [ ]

[feature] Device will send agent in request [ ]
