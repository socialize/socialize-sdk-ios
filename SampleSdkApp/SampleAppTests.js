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
    assertEquals("Tests", mainWindow.navigationBar().name());
 	UIALogger.logMessage("end authenticate");
});

test("GetEntity", function(target, app) {
    // check navigation bar
	mainWindow = app.mainWindow();
  	navBar = mainWindow.navigationBar();

	mainWindow.logElementTree();
	var tableViews = mainWindow.tableViews();
	var tableView = tableViews[0];
	var cell = tableView.cells()[0]; 

	cell.tap();
	cell.waitForInvalid();
	mainWindow = app.mainWindow();
	mainWindow.logElementTree();

	var textfields = mainWindow.textFields();
	var buttons = mainWindow.buttons();

 	UIALogger.logMessage("before get entity");

	var getEntityTextField = textfields["entityField"];
	var getEntityButton = buttons["getEntityButton"];
	var hiddenButton = buttons[0];
	
 	UIALogger.logMessage("hidden button" + hiddenButton);

	getEntityTextField.setValue("http://www.bbc.co.uk");
	getEntityButton.tap();
	
	hiddenButton.waitForInvalid();
	var updatedtextfields = UIATarget.localTarget().frontMostApp().mainWindow().textFields();
	var successLabel = updatedtextfields["resultTextField"].value();

 	UIALogger.logMessage("sucessLabel Value" + successLabel);
    assertEquals("success", successLabel);

 	var navBar = mainWindow.navigationBar();
 	navBar.buttons()["Tests"].tap();
	getEntityButton.waitForInvalid();
});

test("CreateEntity", function(target, app) {
    // check navigation bar
	mainWindow = app.mainWindow();
  	navBar = mainWindow.navigationBar();

 	UIALogger.logMessage("before pushing create entity");
	mainWindow.logElementTree();
	var tableViews = mainWindow.tableViews();
	var tableView = tableViews[0];
	var cell = tableView.cells()[1]; 

	cell.tap();
	cell.waitForInvalid();
	mainWindow = app.mainWindow();

	var textfields = mainWindow.textFields();
	var buttons = mainWindow.buttons();

 	UIALogger.logMessage("before create entity");
	mainWindow.logElementTree();

	var getEntityTextField = textfields["entityField"];
	var nameTextField = textfields["nameField"];
	var createButton = buttons["createButton"];
	var hiddenButton = buttons[0];
	
 	UIALogger.logMessage("hidden button" + hiddenButton);

	getEntityTextField.setValue("http://www.hello.uk");
	nameTextField.setValue("tests");
	createButton.tap();
	
	hiddenButton.waitForInvalid();
	var updatedtextfields = UIATarget.localTarget().frontMostApp().mainWindow().textFields();
	var successLabel = updatedtextfields["resultTextField"].value();

 	UIALogger.logMessage("sucessLabel Value" + successLabel);
    assertEquals("success", successLabel);

 	var navBar = mainWindow.navigationBar();
 	navBar.buttons()["Tests"].tap();
	createButton.waitForInvalid();
});

test("CreateComment", function(target, app) {
    // check navigation bar
	mainWindow = app.mainWindow();
  	navBar = mainWindow.navigationBar();

 	UIALogger.logMessage("before pushing create comment");
	mainWindow.logElementTree();
	var tableViews = mainWindow.tableViews();
	var tableView = tableViews[0];
	var cell = tableView.cells()[2]; 

	cell.tap();
	cell.waitForInvalid();
	mainWindow = app.mainWindow();

	var textfields = mainWindow.textFields();
	var buttons = mainWindow.buttons();

 	UIALogger.logMessage("before create comment");
	mainWindow.logElementTree();

	var getEntityTextField = textfields["entityField"];
	var commentTextField = textfields["commentField"];
	var createButton = buttons["createButton"];
	var hiddenButton = buttons[0];
	
 	UIALogger.logMessage("hidden button" + hiddenButton);

	getEntityTextField.setValue("http://www.hello.uk");
	commentTextField.setValue("a new test comment");
	createButton.tap();
	
	hiddenButton.waitForInvalid();
	var updatedtextfields = UIATarget.localTarget().frontMostApp().mainWindow().textFields();
	var successLabel = updatedtextfields["resultTextField"].value();

 	UIALogger.logMessage("sucessLabel Value" + successLabel);
    assertEquals("success", successLabel);

 	var navBar = mainWindow.navigationBar();
 	navBar.buttons()["Tests"].tap();
	createButton.waitForInvalid();
});

test("GetComments", function(target, app) {
    // check navigation bar
	mainWindow = app.mainWindow();
  	navBar = mainWindow.navigationBar();

	var tableViews = mainWindow.tableViews();
	var tableView = tableViews[0];
	var cell = tableView.cells()[3]; 

	cell.tap();
	cell.waitForInvalid();
	mainWindow = app.mainWindow();

	var textfields = mainWindow.textFields();
	var buttons = mainWindow.buttons();

	var getEntityTextField = textfields["entityField"];
//	var commentTextField = textfields["commentField"];
	var getCommentsButton = buttons["getCommentsButton"];
	var hiddenButton = buttons[0];
	
 	UIALogger.logMessage("hidden button" + hiddenButton);

	getEntityTextField.setValue("http://www.bbc.co.uk");
	getCommentsButton.tap();
	
	hiddenButton.waitForInvalid();
	var updatedtextfields = UIATarget.localTarget().frontMostApp().mainWindow().textFields();
	var successLabel = updatedtextfields["resultTextField"].value();

 	UIALogger.logMessage("sucessLabel Value" + successLabel);
    assertEquals("success", successLabel);

 	var navBar = mainWindow.navigationBar();
 	navBar.buttons()["Tests"].tap();
	getCommentsButton.waitForInvalid();
});

test("like", function(target, app) {
    // check navigation bar
	mainWindow = app.mainWindow();
  	navBar = mainWindow.navigationBar();

	var tableViews = mainWindow.tableViews();
	var tableView = tableViews[0];
	var cell = tableView.cells()[6]; 

	cell.tap();
	cell.waitForInvalid();
	mainWindow = app.mainWindow();

	var textfields = mainWindow.textFields();
	var buttons = mainWindow.buttons();

	var getEntityTextField = textfields["entityField"];
	var likeButton = buttons["likeButton"];
	var hiddenButton = buttons[0];
	
 	UIALogger.logMessage("hidden button" + hiddenButton);

	getEntityTextField.setValue("http://www.bbc.co.uk");
	likeButton.tap();
	
	hiddenButton.waitForInvalid();
	var updatedtextfields = UIATarget.localTarget().frontMostApp().mainWindow().textFields();
	var successLabel = updatedtextfields["resultTextField"].value();

 	UIALogger.logMessage("sucessLabel Value" + successLabel);
    assertEquals("success", successLabel);

});

test("unlike", function(target, app) {
	mainWindow = app.mainWindow();
  	navBar = mainWindow.navigationBar();

	var textfields = mainWindow.textFields();
	var buttons = mainWindow.buttons();

	var getEntityTextField = textfields["entityField"];
	var likeButton = buttons["unlikeButton"];
	var hiddenButton = buttons[0];
	
 	UIALogger.logMessage("hidden button" + hiddenButton);

	getEntityTextField.setValue("http://www.bbc.co.uk");
	likeButton.tap();
	
	hiddenButton.waitForInvalid();
	var updatedtextfields = UIATarget.localTarget().frontMostApp().mainWindow().textFields();
	var successLabel = updatedtextfields["resultTextField"].value();

 	UIALogger.logMessage("sucessLabel Value" + successLabel);
    assertEquals("success", successLabel);

 	var navBar = mainWindow.navigationBar();
 	navBar.buttons()["Tests"].tap();
	likeButton.waitForInvalid();
});
