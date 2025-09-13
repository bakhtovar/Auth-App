//
//  SignUpViewModelTests.swift
//  AuthAppTests
//
//  Created by Bakhtovar Umarov on 9/12/25.
//

import Testing

import XCTest
@testable import AuthApp

final class SignUpViewModelTests: XCTestCase {
    var sut: SignUpViewModel!
    var mockRegister: MockRegisterUseCase!
    var appState: AppState!
    
    override func setUp() {
        super.setUp()
        mockRegister = MockRegisterUseCase()
        appState = AppState()
        sut = SignUpViewModel(appState: appState, register: mockRegister!)
    }
    
    override func tearDown() {
        sut = nil
        mockRegister = nil
        appState = nil
        super.tearDown()
    }
    
    func test_emptyName_shouldShowError() {
        sut.fullName = ""
        sut.email = "test@mail.com"
        sut.password = "123456"
        sut.phone = "12345"
        sut.birthDate = Calendar.current.date(byAdding: .year, value: -20, to: Date())!
        
        sut.submit()
        
        XCTAssertEqual(sut.errorMessage, "Please enter your name")
    }
    
    func test_invalidEmail_shouldShowError() {
        sut.fullName = "Test User"
        sut.email = "invalid_email"
        sut.password = "123456"
        sut.phone = "12345"
        sut.birthDate = Calendar.current.date(byAdding: .year, value: -20, to: Date())!
        
        sut.submit()
        
        XCTAssertEqual(sut.errorMessage, "Invalid email address")
    }
    
    func test_underage_shouldShowError() {
        sut.fullName = "Test User"
        sut.email = "test@mail.com"
        sut.password = "123456"
        sut.phone = "12345"
        sut.birthDate = Calendar.current.date(byAdding: .year, value: -16, to: Date())! // 16 лет
        
        sut.submit()
        
        XCTAssertEqual(sut.errorMessage, "You must be at least 18 years old")
    }
    
    func test_validInput_shouldCallRegisterAndSetAppState() async throws {
        // given
        sut.fullName = "Bakhtovar Umarov"
        sut.email = "test@mail.com"
        sut.password = "123456"
        sut.phone = "1010101011"
        sut.birthDate = Calendar.current.date(byAdding: .year, value: -23, to: Date())!
        
        sut.submit()
        
        try await Task.sleep(nanoseconds: 200_000_000)
        
        XCTAssertTrue(mockRegister.didExecute)
        XCTAssertEqual(appState.currentUser?.email, "bakhtovar@gmail.com")
        XCTAssertEqual(appState.route, Route.main)
    }
}

