#import "jasmine-uiautomation.js"
#import "jasmine-uiautomation-reporter.js"

// Import your JS spec files here.
// #import "foo-spec.js"

jasmine.getEnv().addReporter(new jasmine.UIAutomation.Reporter());
jasmine.getEnv().execute();
