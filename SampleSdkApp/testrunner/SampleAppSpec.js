#import "tuneup.js"
//#import "comments.json"
#import "config.js"


describe("First page should let user authenticate", function() {

    var target = UIATarget.localTarget();
    target = UIATarget.localTarget();
    app = target.frontMostApp();         
    function getLabel() {
        return target.frontMostApp().mainWindow().staticTexts()[0].value();
    }

    it("user should able to authenticate by tap on button", function() {
 	    UIALogger.logMessage("before authenticate");
    	UIATarget.localTarget().pushTimeout(1);
        mainWindow = app.mainWindow();
        UIATarget.localTarget().popTimeout();
        
	    var textfields = mainWindow.textFields();
        textfields["key"].setValue(consumer_key);
	    textfields["secret"].setValue(consumer_secret); 
        target.frontMostApp().mainWindow().buttons()["authenticate"].tap();
    	target.frontMostApp().mainWindow().buttons()["authenticate"].waitForInvalid();        
        expect( mainWindow.navigationBar().name());
 	    UIALogger.logMessage("end authenticate");         
    });
});

