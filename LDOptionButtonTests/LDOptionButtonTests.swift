//
//  LDOptionButtonTests.swift
//  LDOptionButtonTests
//
//  Created by Lajos Deme on 2021. 04. 03..
//

import XCTest
@testable import LDOptionButton

class LDOptionButtonTests: XCTestCase {
    
    let configs = [
        SideButtonConfig(backgroundColor: .blue, normalIcon: "person"),
        SideButtonConfig(backgroundColor: .green, normalIcon: "person"),
        SideButtonConfig(backgroundColor: .red, normalIcon: "person")
    ]
    let optionButton = LDOptionButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100), normalIcon: "person", selectedIcon: "xmark", buttonsCount: 3, sideButtonConfigs: [], duration: 0.2)
    let view = UIView()
    
    override func setUpWithError() throws {
        optionButton.distance = 50
        optionButton.startAngle = 0
        optionButton.endAngle = 90
        optionButton.sideButtonSize = CGSize(width: 75, height: 75)
        view.addSubview(optionButton)

    }

    override func tearDownWithError() throws {
    }

    func testShowButtons() {
        optionButton.showButtons()
        XCTAssertEqual(optionButton.buttons?.count, 3)
    }
    
    
    func testHideButtons() {
        optionButton.hideButtons()
        XCTAssertNil(optionButton.buttons)
    }
}
