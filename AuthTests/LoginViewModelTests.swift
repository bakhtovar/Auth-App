//
//  LoginViewModelTests.swift
//  AuthTests
//
//  Created by Bakhtovar Umarov on 9/12/25.
//

import Testing

import XCTest
@testable import AuthApp

final class LoginViewModelTests: XCTestCase {
    var sut: LoginViewModel!
    var mockRepo: MockAuthRepository!
    
    override func setUp() {
        super.setUp()
        mockRepo = MockAuthRepository()
        sut = LoginViewModel(
            login: LoginUseCase(repo: mockRepo),
            profileRepo: DummyProfileRepo(),
            appState: AppState()
        )
    }
    
    override func tearDown() {
        sut = nil
        mockRepo = nil
        super.tearDown()
    }
    
    func test_emptyEmail_shouldShowError() {
        sut.email = ""
        sut.password = "123456"
        
        sut.submit()
        
        XCTAssertEqual(sut.errorMessage, "Неверный формат email")
    }
    
    func test_validCredentials_callsRepository() {
        sut.email = "test@mail.com"
        sut.password = "123456"
        
        sut.submit()
        
        XCTAssertTrue(mockRepo.didLogin)
    }
}
