#import "jasmine-uiautomation.js"

jasmine.UIAutomation.Reporter = function() {
  var self = new jasmine.Reporter();
  
  self.reportSpecStarting = function(spec) {
    UIALogger.logStart(spec.getFullName());
  };
  
  self.reportSpecResults = function(spec) {
    var results = spec.results();
    if (results.passed()) {
      UIALogger.logPass("Passed");
    } else {
//      UIATarget.localTarget().captureScreenWithName(spec.getFullName());
      UIALogger.logFail(failureMessageFor(results));
    }
  };
  
  self.log = function(string) {
    UIALogger.logDebug(string);
  };
  
  return self;
  
  function failureMessageFor(results) {
    var message = "";
  
    var resultItems = results.getItems();
    for (var i = 0; i < resultItems.length; ++i) {
      var result = resultItems[i];
      if (result.passed && !result.passed()) {
        message += result.message + "\n";
      }
    }
    return message;
  }
};
