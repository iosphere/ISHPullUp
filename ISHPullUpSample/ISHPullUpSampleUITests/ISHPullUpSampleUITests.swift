//
//  ISHPullUpSampleUITests.swift
//  ISHPullUpSampleUITests
//
//  Created by Felix Lamouroux on 25.06.16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

import XCTest

class ISHPullUpSampleUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testTapping() {
        let app = XCUIApplication()
        app.buttons["Drag up or tap"].tap()
        app.buttons["Drag down or tap"].tap()
        app.buttons["Drag up or tap"].tap()
    }
}
