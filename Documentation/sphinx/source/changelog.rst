.. include:: feedback_widget.rst

=============================================
Changelog
=============================================

v2.8.2
------
[bug] Socialize should no longer send device MAC address [ ]

v2.8.1
------
[feature] Added FAQ to Documentation

v2.8
----
[feature] Update twitter to use 1.1 API instead of 1.0 [ ]

[feature] Remove use of UDID (Only send Advertiser ID) [ ]

[feature] Expose Like Options on action bar [ ui ]

[feature] Add call to get SDK version [ sdk ]

[feature] Add hook to override comments notification behavior [ ui ]

[bug] Default for token registration should be production [ ]

[feature] Add ability to post multipart in share calbacks [ twitter ]

[feature] Share options have 'image' helper property for adding image to share/like (Twitter only) [ ]

[bug] Fix a possible crash at share dialog dismissal time (modified after being freed) [ ]

v2.7.2
------
[bug] Fix a major issue with linking to a third party on iOS5 devices [ ]

v2.7.1
------
[bug] Fix double called of SZDidCreateObjectsNotification [ ]

[bug] Fix doc examples for SZDidCreateObjectsNotification [ ]

v2.7
----
[bug] Fix a crash that could occur when a socialize response arrived after a socialize instance has been deallocated [ crash critical ]

[feature] Developer can receive notifications for api operations such as comment, like, share creation/deletion [ ]

[bug] Add workaround for an MKMapView leak [ memory ]

[bug] Comment composer deallocation could be delayed by up to 10 seconds [ memory ui ]

[feature] Socialize Service Delegate now called for all cases (was not called for certain block operations) [ api-client regression ]

[bug] Minor leak fixes [ memory ]

[feature] documentation suggestion for meta/share [ documentation ]

v2.6.2
------
[bug] Fix several memory issues [ critical ]

[feature] Add Twitter dashboard config to Twitter section [ docs ]

v2.6.1
------
[feature] Display of share composer can be disabled [ ]

[feature] Share composer should adopt default text from share options [ ]

[bug] Share composer should allow blank share [ ]

[feature] Expose share options in social 'posting' callbacks [ ]

[feature] Twitter text now shows ellipses when truncated [ ]

[bug] Fix some additional memory leaks [ ]

[bug] Fix circular ref that occured from action bar on first unauthed action [ ]

v2.6
----
[bug] Socialize can interfere with developer's UIWebViewDelegates [ ]

[feature] Dev can hide or show individual share dialog elements [ share ui ]

[bug] Remove deprecated REST wrappers (/view/ GETs) [ ]

[bug] Developer can use twitter multipart endpoints such as status_with_media [ getsat ]

[bug] Fix crash when manually creating nil-named entity/entities [ crash ]

[bug] Share link is generated for application and not entity SmartDownload page [ needed for ellen ]

[feature] Share dialog now always shows a text composer [ ]

[feature] the SDK should report the new iOS 6 advertiserIdentifier [ ]

[bug] EntityLoader for DeepLinking is not clear in docs [ ]


v2.5
----
[bug] Add prefix to [NSString trim] (conflict with another library) [ ]

[feature] Add custom thirdparty share to action bar section [ docs ]

[bug] Fix auth screen iPad landscape dismissal crash [ ]

[bug] Fix iOS6 formsheet modal (iPad) parent resize issue [ ]

[bug] deleteLikeForUser can crash when called with createLikes... [ ]

[feature] Action bar draws as normal view hierarchy (allow transparency, custom UIImageView) [ ]

v2.4.4
------
[bug] Clarify older -fobjc-arc xcode setting in docs [ ]

[bug] Like button docs missing property section [ ]

[bug] Remove ifdef DEBUG from smartalerts setup guide (no longer needed) [ ]

[feature] Add docs for customizing twitter propagations [ ]

[bug] Fix 'not configured' message when using fb but not twitter [ ]

[feature] Add explicit parameter for sending sandbox tokens [ ]

v2.4.3
------
[feature] Allow overriding share options when showing share dialog [ ]

[feature] Expose share options override on action bar [ ]

[bug] Add missing smartdownload config step to docs [ ]

[bug] Twitter posts should autotruncate to 140 characters for long text or name [ ]

[bug] Fix imagescache crash [ ]

v2.4.2
------
[bug] Cancel during comment creation does not properly abort [ ]

[bug] Comment showing share dialog when no social networks configured [ ]

[bug] Comments double posting when no social networks configured [ ]

v2.4.1
------
[feature] Socialize Binary Release should include armv7s slice [ ios6 ]

[bug] Fix iOS6 ActivityDetails crash (doubly referenced view log message) [ ios6 ]

[bug] Fix a bug where a direct entity notification could prevent further notifications from displaying correctly [ ]

[feature] Socialize should support nonstandard phone sizes [ ]

[bug] Some code paths do not respect canLoadEntity [ ]

v2.4
----
[feature] Comment composer supports iPad formsheet modal [ ]

[bug] SDK should stop trying to autopost when autopost enabled and credentials expire [ ]

[feature] Share completion should show success message [ ]

[feature] Tapping outside of iPad modal should dismiss modal [ publicize ]

[bug] Email/SMS rows remain illuminated after returning to share dialog on iPad [ sharing ]

[feature] Post Comment reverse geocoding should retry on failure [ ]

[feature] Enable landscape in profile, settings, link [ ]

[bug] comments list not refreshed after adding new comment [ ]

[bug] comments count not refreshed after adding new comment [ actionbar ]

[feature] action buttons receive event if entity modified [ ]

[feature] 'Continue' should have context-sensitive text (comment and share, like and share) [ ]

[feature] Propagation screen for like, comment have more descriptive title than 'Share' [ ui ]

[bug] Event logging now autoauths [ ]

[feature] UI behavior is more configurable during notification handling [ ]

[bug] Activity Details should always support landscape [ ]

[bug] Doc logic for distinguishing foreground/background notification is reversed [ ]

[bug] Socialize should never automatically present a new navigation controller during the entity load process [ ]

[bug] New push registrations on live apps are being incorrectly flagged as debug [ ]

[bug] Add note to docs on forcing production or development push [ ]

[feature] Socialize should automatically handle SmartDownloads [ ]

v2.3.5
------
[bug] Fix nonarc / iOS 4 crash when building with latest Xcode [ ]

[feature] Link dialog should not show UIAlertView before facebook callout [ ]

[bug] Facebook auth fix not included in v2.3.4 release as advertised [ ]

[feature] Developer can disable all location prompting and tracking in Socialize [ ]

v2.3.4
------
[bug] FB Auth should always remain in-app if UIApplicationExitsOnSuspend=YES [ facebook ]

v2.3.3
------
[bug] Development/Sandbox push certificates not being flagged correctly with api [ notifications ]

[feature] End-user will get a bubble that they can turn off notifications for this thread after opening app from thread based notifications [ notifications ]

[feature] Remember post to no networks for comment/like ('Always post' becomes 'Remember Selection') [ ui ]

[feature] Add override hook for sms/email [ share ]

v2.3.2
------
[bug] Fix isForCurrentSocializeSession crash [ ]

v2.3.1
------
[feature] Improve settings sign-in / sign-out interface (now similar to Android) [ profile ]

[bug] Autopost setting not being respected [ facebook twitter ]

[bug] Back-navigation during first third party link not working [ authentication ]

[bug] Twitter direct api calls should auto auth if needed [ twitter ]

[bug] All facebook oauth failures should wipe local creds [ facebook ]

[bug] Immediately autoextend facebook token on foreground [ authentication facebook ]

v2.3
----
[feature] Allow setting type on entities [ ]

[feature] Developer can override social network post path (previously only params could be overriden) [ ]

[feature] Socialize likes can propagate as OG like on Facebook [ ]

[feature] Propagations for likes which use FB OG should include an extra param, "og_action=like" [ ]

[feature] Improve docs and support related to required socialize fb perms / authing on your own [ ]

[feature] Improve social network hooks (success has server result, failure has server error) [ ]

[feature] Add note about deep linking to docs [ ]

[bug] Fix a 'bad image reference' error log [ ]

v2.2.1
------
[bug] Fix a case where device token would not be sent on startupa [ ]

[bug] Subscriber-only smartalerts not being handled correctly [ ]

[feature] Add note to docs on subscriber-only smartalerts [ ]

[feature] add entity-notification as a subscription type [ publicize ]

[bug] developer_notification type should be eaten by handleSocializeNotification [ ]

[feature] Add docs and better support for handling notifications while in foreground [ ]

[bug] Fix 'server refusing to fulfill request' problem with initial twitter posts [ ]

v2.2
----
[feature] Share decisions from end user should be reported via event tracker [ ]

[feature] Auth decisions from end user should be reported via event tracker [ ]

[bug] Fix a comments list crash when returning after comment post under certain conditions [ ]

[feature] Documentation has new info on overriding web entity display [ ]

[feature] Mobile app session opens and closes are tracked and reported [ ]

[feature] Developer can get comments by application [ ]

[feature] Developer can get likes by application [ ]

[feature] Developer can get shares by application [ ]

[feature] Developer can list entities by popularity [ ]

[feature] Documentation has new info on testing sandbox push [ ]

[bug] tapping profile in activity details should navigate to that profile [ ]

[feature] Developer can customize header view (image) in share dialog [ ]

[feature] Pressing views count should go directly to settings [ ]

[feature] Improve placement of continue button in share dialog [ ]

[feature] Developer can customize footer view in share dialog [ ]

[feature] Share dialog 'continue' now greyed out unless something is selected [ ]

[feature] Improve default twitter link controller title [ ]

v2.1.2
------
[bug] Fix another comments list crash [ ]

[feature] Support landscape in comments list [ ]

[feature] Developer can disable logout buttons in settings [ ]

v2.1.1
------
feature] Allow customization of title in share dialog [ ]

[feature] Support landscape during twitter link [ ]

[bug] Email composer showing "123" for subject [ ]

[feature] Clarity and troubleshooting updates for twitter docs [ ]

[feature] Add note to docs on setting -fobjc-arc (older xcode) [ ]

[bug] Fix a comments list cell background display problem on device [ ]

[feature] Show description / bio in profile [ ]

[feature] Make 'add as folder' when dragging very explicit in docs / getting started [ ]

[bug] Fix a crash related to dismissing the comments list [ ]

v2.1
----

[feature] Tweet from client [ ]

[bug] Views are not incrementing on action bar [ ]

[bug] Reenable a project setting so some failures are more obvious [ ]

[feature] specify prod or dev in token registration call for better web feedback / smartalerts debugging [ ]

[feature] Developer can customize the content of Twitter Posts [ ]

v2.0.4
------

[feature] Clean up facebook propagations for like, comment, share [ ]

[bug] Share dialog not showing loading indicator on share [ ]

[bug] Profile edit save button not enabled for some cases [ ]

[bug] Updating user settings should update globally stored user [ ]

v2.0.3
------

[feature] Add slightly more verbose facebook error logging [ ]

[bug] Facebook is sharing application link, not entity link [ ]

[feature] Add doc note on required permissions when authenticating on your own [ ]

[feature] Add doc example for manual graph post [ ]

v2.0.2
------

[bug] Fix a header problem with the 2.0.1 release

v2.0.1
------

[bug] Fix action bar code in getting started section [ ]

[bug] Fix missing text for twitter share from share dialog [ ]

[bug] Old (unused) social network buttons show briefly on first comment composer load [ ]

[feature] Add failed to post warning for Facebook wall posts [ ]

[feature] Add docs for managing the bundled controllers on your own [ ]

[bug] Fix unrecognized selector dismissViewControllerAnimated:completion: [ ios4 ]

v2.0
----

[bug] armv6 not being bundled (support older devices)

[feature] Add facebook image post docs [docs]

[feature] Add docs on showing link dialog

[bug] Fix Comment Composer layout issues

[bug] SMS share showing n/a

[bug] User profile not modifiable after some third party changes (You didn't create this)

[bug] Fix some symbol collisions (SBJSON, Facebook, JSONKit, Blockskit) 


[feature] Add an upgrading section to the documentation [ ]

[feature] Deprecate old action bar [ ]

[feature] Add a 2.0-specific upgrading section to the documentation [ ]

[feature] Update documentation for clearer entity loader information [ ]

[bug] Fix memory leaks [ ]


[bug] Fix share dialog crash when twitter or facebook unconfigured. [ ]

[bug] Email and SMS are missing default text [ ]

[bug] SZUserSettingsChanged notification should include both settings and user [ ]

[bug] First profile load was not configuring correctly [ ]

[bug] If changing users in settings, profile controller one level up does not update to the new user [ ]

[feature] Expose action bar refresh call [ ]

[bug] Action bar should autorefresh on user change [ ]

[bug] References to view controller in action bar and like button should not be strong [ ]


[feature] Add block callbacks to socialize api client [ ]

[feature] Reorganize core functionality into 'utils' classes

[feature] Remake sample app [ ]

[feature] Add SZ Prefix and simplify names of front facing UI controllers, deprecate old names [ ]

[feature] Facebook shares should post to "links" endpoint, not "feed" endpoint [ ]

[feature] Facebook/twitter now available for all actions (moved from compose comment to share sheet) [ ]

[feature] SDK Calls automatically create an anon user when necessary (when using utils classes) [ ]

[feature] Update to latest facebook SDK version [ publicize ]

[feature] Add facebook link callback for app foreground (neither authed nor cancelled) [ publicize ]

[feature] Project rebuilt from scratch [ ]

[feature] Update FB auth to handle Facebook's deprecation of offline_access [ ]

[feature] Add consistent, configurable location sharing for all actions [ ]

[bug] Fix an inappropriate emission of 'unconfigured social network' log messages [ ]

[feature] Comment details screen redesign [ ]

[feature] Rewrite action bar for performance, configurability, and new interfaces [ ]

[bug] Change blue socialize navigation bar button back to correct style [ ]

[feature] Add programmatic saving of user settings [ ]

[feature] Expose ability to post directly to facebook graph [ ]

v1.7.7
------
[bug] Token registration should auto auth if needed [ ]

[bug] Changing consumer keys should wipe existing user. [ ]

[feature] Dev can dismiss push notification popups programatically [ ]

v1.7.6
------
[feature] Add ability to show share action sheet directly

v1.7.5
------
[bug] External links such as iTunes should open for direct url requests [ ]

[bug] Direct URL entities should work if scheme unspecified [ ]

v1.7.4
------
[feature] Add launch-time notification handling info to documentation [ ]

[bug] Direct-URL smartalerts are crashing [ ]

v1.7.3
------
[bug] Cancelling auth does not work from post comment [ ui ]

[bug] Action Bar should not refetch entity after view creation [ actionbar ]

[bug] Entity name should show on facebook wall comment. like, share [ facebook ]

[bug] Remove "using Socialize for iOS" from Facebook wall posts [ ]

v1.7.2
------
[bug] Fix bug where sms share might be sent to twitter [ ]

[bug] Activity creates slow due to too many url shortens [ ]

[feature] Expose socialize branded navigation controller [ ]

[feature] Clean up static utilities for profile and profile edit [ ]

[feature] Expose authenticated full user object (previously partial user) [ ]

[feature] Improve quality of code samples [ ]

[feature] Change title of Profile Edit to Settings [ ]

[bug] iPad is crashing when updating profile (UIImagePickerController) [ ]

v1.7.1
------
[bug] Fix PostComment keyboard crash after low-memory event [ crash memory ]

[feature] Improve failure text for missing SocializeConfigurationInfo.plist [ ]

[bug] SocializeAuthViewController needs a back or cancel button to completely cancel the flow [ ]

[feature] Include an example entity loader in release distrubution (SampleEntityLoader) [ ]

[bug] Action bar not reporting like error [ ]

[bug] iPad layout broken in activity, profile, and profile edit [ ]

v1.7
----
[feature] Expose user-specific likes GET endpoint in SDK [ ]

[feature] Developer can add a stand-alone like button [ Piecemeal UI Components ]

v1.6.5
------
[bug] Fix iPad form factor when posting comment, listing comments, and linking to third party

v1.6.4
------
[feature] Allow pagination in get application activity [ ]

[bug] Third party link dialog is being reshown on relike [ ]

[bug] Like from action bar creating under wrong user [ ]

v1.6.3
------
[feature] prompt authentication on likes [ ]

[bug] Entity name not being propagated through action bar [ ]

[feature] developer can hide/show 'id rather not' text on auth screen with parameter [ ]

[feature] Developer can enable/disable prompt auth on action (See Advanced UI Section in Documentation) [ ]

[bug] Fix a bad notifications image reference in comments list [ ]

v1.6.2
------
[bug] Using SMS crashes appmakr app. [ appmakr ]

[bug] Facebook wall post app link incorrectly showed entity name [ ]

[bug] Add missing docs for explicit Facebook linking [ ]

[feature] Improve look of Post Comment action buttons [ ]

[feature] Remove getsocialize.com link from Facebook wall posts [ ]

v1.6.1
------
Update notification registration docs to reduce registration of invalid tokens

v1.6
----
[feature] Developer can send direct url to user as SmartAlert [ ]

[feature] Developer can send direct entity to user as SmartAlert [ ]

[feature] Add documentation for getting device token from logs [ ]

[feature] Device calls events endpoint on notification open [ ]

[feature] Email and SMS include app/entity links [ ]

v1.5.5
------
[bug] UI should not be blocked on manual return from fb auth [ facebook authentication]

[bug] In-app modal facebook dialog should work (support certain devices that cannot open to safari/fb) [ facebook authentication ]

[bug] Fix memory leaks [ memory ]

v1.5.4
------
[bug] Fix a bug where consumer key could be unset before using Socialize UI or when doing manual third party link [ ]

v1.5.3
------
[bug] Fix double display of settings after auth controller [ ]

[bug] Fix modal transition crash on iOS 4.2 and earlier [ ]

[bug] Socialize app link on facebook wall incorrect [ ]

[bug] ActionBar Share via twitter / fb would not show text composer on first run [ ]

v1.5.2
------
[bug] iOS 4.3 crashes at end of twitter authentication [ ]

[bug] "View Entity" button label on comment details is too wide [ ]

[bug] Remove an unused property that is causing some warnings (LoaderFactory) [ ]

[bug] Hide an undocumented method that should not yet be public [ ]

[bug] Link to twitter from getting started doc [ ]

[bug] Do not attempt to send push token before authenticated (consumer key null) [ ]

[bug] Remove some lingering NSLogs [ ]

[bug] Posting a subscription comment would not subscribe to smartalerts [ ]

[bug] Update confusing facebook url config image in docs [ ]

[bug] Freshly signing in to third party should force autopost enabled [ ]

[bug] Comment actions should disable when loading [ ]

[bug] A twitter auth failure case should show retry dialog [ ]

[bug] Default title as key for entity loader button is ugly

v1.5.1
------
[bug] Logging into third party from profile now shows profile on top of profile [ ]

[bug] Configuring twitter but not Facebook caused a profile controller inconsistency [ ]

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
