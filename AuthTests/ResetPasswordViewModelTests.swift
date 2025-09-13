//
//  ResetPasswordViewModelTests.swift
//  AuthTests
//
//  Created by Bakhtovar Umarov on 9/12/25.
//

import XCTest
import Combine
@testable import AuthApp

final class ResetPasswordViewModelTests: XCTestCase {
    var sut: ResetPasswordViewModel!
    var mockReset: MockResetPasswordUseCase!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockReset = MockResetPasswordUseCase()
        sut = ResetPasswordViewModel(reset: mockReset)
        cancellables = []
    }

    override func tearDown() {
        sut = nil
        mockReset = nil
        cancellables = nil
        super.tearDown()
    }

    func test_invalidEmail_shouldShowError() {
        sut.email = "badEmail"
        sut.newPassword = "123456"

        sut.submit()

        XCTAssertEqual(sut.errorMessage, "Invalid email")
        XCTAssertFalse(mockReset.didExecute)
    }

    func test_shortPassword_shouldShowError() {
        sut.email = "user@mail.com"
        sut.newPassword = "123" // короткий

        sut.submit()

        XCTAssertEqual(sut.errorMessage, "Password ≥ 6")
        XCTAssertFalse(mockReset.didExecute)
    }

    func test_successfulReset_shouldSetDoneTrue() {
        sut.email = "user@mail.com"
        sut.newPassword = "111111"

        let exp = expectation(description: "Reset completes")

        sut.$done
            .dropFirst()
            .sink { value in
                if value {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.submit()

        wait(for: [exp], timeout: 1.0)

        XCTAssertTrue(mockReset.didExecute)
        XCTAssertTrue(sut.done)
        XCTAssertNil(sut.errorMessage)
    }

    func test_failedReset_shouldShowError() {
        sut.email = "user@mail.com"
        sut.newPassword = "123456"
        mockReset.shouldFail = true

        let exp = expectation(description: "Reset fails")

        sut.$errorMessage
            .dropFirst()
            .sink { msg in
                if msg != nil {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.submit()

        wait(for: [exp], timeout: 1.0)

        XCTAssertTrue(mockReset.didExecute)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.done)
    }
}
