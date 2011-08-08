#import "jasmine/lib/jasmine.js"

jasmine.UIAutomation = {};

// Jasmine assumes that the underlying driver (such as a browser) will need xxxx
// access to the thread of execution to update its UI.  This attribute specifies
// how often Jasmine will use a setTimeout call to relinquish the main thread.
// The UIAutomation framework doesn't support setTimout, nor does it need access
// to the main thread, since UI updates happen via API calls that marshall to
// the separate Instruments process.  Setting this to 0 tells Jasmine to never
// give up the main thread.
jasmine.getEnv().updateInterval = 0;

// UIAutomation does not define these functions.  Define them as no-ops here
// because Jasmine tries to manipulate them.
function setTimeout() {}
function clearTimeout() {}
function setInterval() {}
function clearInterval() {}
