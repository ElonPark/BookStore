//
//  BookStoreUITests.swift
//  BookStoreUITests
//
//  Created by Elon on 2021/11/16.
//

import XCTest

class BookStoreUITests: XCTestCase {

    func testSearch() throws {
        let app = XCUIApplication()
        app.launch()

        let bookstoreNavigationBar = app.navigationBars["BookStore"]
        let searchField = bookstoreNavigationBar.searchFields["Search"]

        searchField.tap()
        searchField.typeText("swift")

        app.keyboards.buttons["Search"].tap()
        wait(for: 2.0)

        app.swipeUp()
        wait(for: 0.2)

        app.swipeUp()
        app.tables.element.tap()

        wait(for: 2.0)

        app.swipeUp()
        wait(for: 1.0)

        let predicate = NSPredicate(format: "label CONTAINS 'http'")
        app.cells.containing(predicate).firstMatch.tap()
        wait(for: 2.0)
    }

    func wait(for duration: TimeInterval) {
        let waitExpectation = expectation(description: "Waiting")

        let when = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: when) {
            waitExpectation.fulfill()
        }

        waitForExpectations(timeout: duration + 0.5)
    }
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
