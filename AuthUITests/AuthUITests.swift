//
//  AuthUITests.swift
//  AuthUITests
//
//  Created by Bakhtovar Umarov on 9/12/25.
//

import XCTest

final class AuthUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func test_login_withInvalidEmail_showsError() {
        // Открыт экран Login
        let emailField = app.textFields["Loisbecket@gmail.com"]
        emailField.tap()
        emailField.typeText("wrongEmail")
        
        let passwordField = app.secureTextFields["••••••••"]
        passwordField.tap()
        passwordField.typeText("123456")
        
        app.buttons["Log In"].tap()
        
        XCTAssertTrue(app.staticTexts["Неверный формат email"].exists)
    }
    
    func test_login_withValidInput_navigatesToMain() {
        let emailField = app.textFields["Loisbecket@gmail.com"]
        emailField.tap()
        emailField.typeText("test@gmail.com")
        
        let passwordField = app.secureTextFields["••••••••"]
        passwordField.tap()
        passwordField.typeText("123456")
        
        app.buttons["Log In"].tap()
        
        // проверяем что появился главный экран
        XCTAssertTrue(app.staticTexts["Здравствуйте"].waitForExistence(timeout: 10))
    }
    
    func test_navigate_toSignUp_andBack() {
        app.buttons["Sign Up"].tap()
        XCTAssertTrue(app.staticTexts["Sign up"].exists)
        
        app/*@START_MENU_TOKEN@*/.buttons["chevron.left"]/*[[".otherElements",".buttons[\"Back\"]",".buttons[\"chevron.left\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        XCTAssertTrue(app.buttons["login_button"].waitForExistence(timeout: 5))
    }
    
    func test_resetPassword_flow() {
        app.buttons["Forgot Password ?"].tap()
        
        XCTAssertTrue(app.staticTexts["Reset Password"].exists)
        
        let emailField = app.textFields["email@example.com"]
        emailField.tap()
        emailField.typeText("wrongEmail")
        
        
        let passwordField = app.secureTextFields["reset_password"]
        passwordField.tap()
        passwordField.typeText("123456")
        
        app.buttons["Set New Password"].tap()
        XCTAssertTrue(app.staticTexts["Invalid email"].exists)
        
        // Вводим корректные данные
        emailField.tap()
        emailField.doubleTap()
        
        emailField.typeText("valid@mail.com")
        
        let newPass = app.secureTextFields["reset_password"]
        newPass.tap()
        newPass.typeText("123456")
        
        app.buttons["Set New Password"].tap()
        
        XCTAssertTrue(app.staticTexts["success_message"].waitForExistence(timeout: 10))
    }
    
    func test_signUp_withValidInput_shouldNavigateToMain() {
        // 1. Открываем экран регистрации
        app.buttons["login_signup"].tap()
        XCTAssertTrue(app.staticTexts["Sign up"].exists)
        
        // 2. Заполняем форму
        let fullName = app.textFields["signup_fullName"]
        fullName.tap()
        fullName.typeText("Test User")
        
        let email = app.textFields["signup_email"]
        email.tap()
        email.typeText("newuser@mail.com")
        
        app/*@START_MENU_TOKEN@*/.datePickers.buttons["Date Picker"]/*[[".datePickers",".buttons.firstMatch",".buttons[\"Date Picker\"]"],[[[-1,2],[-1,0,1]],[[-1,2],[-1,1]]],[1,0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["DatePicker.Show"].staticTexts.firstMatch/*[[".buttons[\"DatePicker.Show\"].staticTexts.firstMatch",".buttons.staticTexts[\"September 2025\"]",".staticTexts[\"September 2025\"]"],[[[-1,2],[-1,1],[-1,0]]],[2]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.pickerWheels["2025"]/*[[".pickers.pickerWheels[\"2025\"]",".pickerWheels[\"2025\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeDown()
        app/*@START_MENU_TOKEN@*/.pickerWheels["September"]/*[[".pickers.pickerWheels[\"September\"]",".pickerWheels[\"September\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        app/*@START_MENU_TOKEN@*/.buttons["PopoverDismissRegion"]/*[[".otherElements",".buttons[\"dismiss popup\"]",".buttons[\"PopoverDismissRegion\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
    
        let phone = app.textFields["signup_phone"]
        phone.tap()
        phone.typeText("123456789")
        
        let password = app.secureTextFields["signup_password"]
        password.tap()
        password.typeText("123456")
        
        app.buttons["signup_register"].tap()
        
        XCTAssertTrue(app.staticTexts["Главный экран"].waitForExistence(timeout: 3))
    }
}
