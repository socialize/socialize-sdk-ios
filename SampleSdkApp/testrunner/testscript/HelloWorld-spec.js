
describe("Hello World App", function() {

    var target = UIATarget.localTarget();
    
    function getLabel() {
        return target.frontMostApp().mainWindow().staticTexts()[0].value();
    }

    it("should display \"Hello World !\" in the label after pressing the \"Click Me :)\" button", function() {
    
        target.frontMostApp().mainWindow().buttons()["Click Me :)"].tap();
        
        expect(getLabel()).toEqual("Hello World !");
    });
    
    it("should display empty string in the label after pressing the \"Reset\" button", function() {
    
        target.frontMostApp().mainWindow().buttons()["Reset"].tap();
    
        expect(getLabel()).toEqual("");
    
        target.frontMostApp().mainWindow().buttons()["Click Me :)"].tap();
        
        expect(getLabel()).not.toEqual("");
        
        target.frontMostApp().mainWindow().buttons()["Reset"].tap();
    
        expect(getLabel()).toEqual("");

    });
});
