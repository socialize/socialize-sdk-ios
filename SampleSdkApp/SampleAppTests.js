#import "tuneup.js"
//#import "comments.json"

target = UIATarget.localTarget();
app = target.frontMostApp();

test("Authenticate", function(target, app) {
  // check navigation bar
	mainWindow = app.mainWindow();
  	navBar = mainWindow.navigationBar();
	var textfields = mainWindow.textFields();
	var buttons = mainWindow.buttons();
	var statictext = mainWindow.staticTexts();
 	UIALogger.logMessage("before authenticate");

	textfields["key"].setValue("90aa0fb5-1995-4771-9ed9-f3c4479a9aaa");
	textfields["secret"].setValue("5f461d4b-999c-430d-a2b2-2df35ff3a9ba");
	var authButton = buttons["authenticate"];
 	UIALogger.logMessage("after authenticate");
	authButton.tap();
	authButton.waitForInvalid();
    assertEquals("Entities", mainWindow.navigationBar().name());
 	UIALogger.logMessage("end authenticate");
});

UIATarget.onAlert = function onAlert(alert) {
	UIALogger.logMessage("alert called");
	alert.logElementTree();
    return false;
}

test("GetEntity", function(target, app) {
    // check navigation bar
	mainWindow = app.mainWindow();
  	navBar = mainWindow.navigationBar();

 	UIALogger.logElementTree("before get entity");
	var rightButton = navBar.rightButton();
	rightButton.tap();
	
 	UIALogger.logMessage("end authenticate");
});