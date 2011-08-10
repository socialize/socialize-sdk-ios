#import "jasmine-iphone/jasmine-uiautomation.js"
#import "jasmine-iphone/jasmine-uiautomation-reporter.js"
#import "jasmine-iphone/jasmine.junit_reporter.js"
//#import "jasmine-iphone/jasmine/lib/jasmine.js"


//#import "SampleAppTests.js"
import "SampleAppSpec.js"


jasmine.getEnv().addReporter(new jasmine.UIAutomation.Reporter());
//jasmine.getEnv().addReporter(new jasmine.TrivialReporter());
jasmine.getEnv().addReporter(new jasmine.JUnitXmlReporter());

jasmine.getEnv().execute();
