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
	app.logElementTree();

	textfields["key"].setValue("90aa0fb5-1995-4771-9ed9-f3c4479a9aaa");
	textfields["secret"].setValue("5f461d4b-999c-430d-a2b2-2df35ff3a9ba");
	var authButton = buttons["authenticate"];

 	UIALogger.logMessage("after authenticate");
	authButton.tap();
	authButton.waitForInvalid();
    assertEquals("Tests", mainWindow.navigationBar().name());
 	UIALogger.logMessage("end authenticate");
});

test("GetEntity", function(target, app) {
    // check navigation bar
	mainWindow = app.mainWindow();
  	navBar = mainWindow.navigationBar();

	var textfields = mainWindow.textFields();
	var buttons = mainWindow.buttons();
	var statictext = mainWindow.staticTexts();

 	UIALogger.logMessage("before get entity");

	var getEntityTextField = buttons["entityField"];
	var getEntityButton = buttons["getEntityButton"];
	getEntityTextField.value = "http://www.bbc.co.uk";
	getEntityButton.tap();
	
 	UIALogger.logMessage("end get entity test");
});