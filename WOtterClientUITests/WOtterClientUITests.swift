import XCTest
import SwaggerClient

class WOtterClientUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app.launch()

        // XCUITest seems to call in before everything is properly setup :-(
        sleep(1)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPostWot() {
        let content = "C\(arc4random() % 1000000)"
        app.buttons["Post"].tap()
        
        app.textFields["login"].tap()
        app.textFields["login"].typeText("Foo")
        
        app.secureTextFields["password"].tap()
        app.secureTextFields["password"].typeText("Foo")
        
        app.textFields["content"].tap()
        app.textFields["content"].typeText(content)
        
        app.buttons["Post!"].tap()
        app.alerts["Success"].collectionViews.buttons["Awesome!"].tap()
        
        app.buttons["Show Wots"].tap()
        // give the web service some time to respond
        sleep(1)
        assertCellIsPresent(title: content, poster: "Foo")
    }
    
    func testPostWotInvalidAuth() {
        app.buttons["Post"].tap()
        
        app.textFields["login"].tap()
        app.textFields["login"].typeText("Foo")
        
        app.secureTextFields["password"].tap()
        app.secureTextFields["password"].typeText("Bar")
        
        app.textFields["content"].tap()
        app.textFields["content"].typeText("CONTENT!")
        
        app.buttons["Post!"].tap()
        app.alerts["Error"].collectionViews.buttons["Too bad"].tap()

        app.navigationBars["WOtterClient.PostWotView"].childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap()
    }
    
    func testListWotsPredefinedContent() {
        app.buttons["Show Wots"].tap()
        // give the web service some time to respond
        sleep(1)
        assertCellIsPresent(title: "WOT?!", poster: "Test")
    }

    private func assertCellIsPresent(title title: String, poster: String) {
        let cells = app.tables.cells
        for i in 0..<cells.count  {
            let cell = cells.elementBoundByIndex(i)
            if checkIfCellIs(cell, title: title, poster: poster) {
                return
            }
        }
        XCTFail("couldn't find entry for \(title) posted by \(poster)")
    }

    private func checkIfCellIs(cell: XCUIElement, title: String, poster: String) -> Bool {
        let labels = cell.staticTexts
        var foundTitle = false
        var foundPoster = false
        for i in 0..<labels.count {
            let label = labels.elementBoundByIndex(i).label
            if label == title {
                foundTitle = true
            } else if label.hasSuffix("by \(poster)") {
                foundPoster = true
            }
        }
        return foundTitle && foundPoster
    }
}
