import AppConfiguration
import Combine
import Foundation
import SharedModels
import UIKit
import XCTest

@testable import NetworkLayer

final class NetworkServiceTests: XCTestCase {
    private var appConfiguration: EnvironmentConfigurationService!
    private var sut: NetworkService!
    private var networkServiceResponse: NetworkResponse!
    private var networkServiceRequest: URLRequest!

    private var cancellable = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()

        appConfiguration = .mock()

        makeSut()
    }

    private func makeSut() {
        sut = .testMock(
            appConfiguration: appConfiguration,
            mockValueProvider: { request  in

            self.networkServiceRequest = request
            return self.networkServiceResponse
        })
    }

    override func tearDown() {
        appConfiguration = nil
        sut = nil
        networkServiceResponse = nil
        networkServiceRequest = nil

        super.tearDown()
    }

    @MainActor
    func testAllEndpointsURLsAndHeaders() async {
        networkServiceResponse = .mock(data: emptyMock!, status: 200)
        appConfiguration = .mock(baseUrl: "www.google.com", accessToken: "43hug534h5g345")
        makeSut()

        for endpoint in Endpoint.allCases {
            do {
                let _: NoReply =  try await sut.call(endpoint: endpoint)

                // Now we have to assert that the headers are correct
                guard let callHeaders = networkServiceRequest.allHTTPHeaderFields else {
                    XCTFail("Couldn't headers on networkServiceRequest")
                    return
                }

                XCTAssertEqual(callHeaders["Content-Type"], "application/json")
                XCTAssertEqual(callHeaders["Accept"], "application/json")

                if endpoint.requiresAccessToken {
                    XCTAssertEqual(callHeaders["Authorization"], "Bearer 43hug534h5g345")
                } else {
                    XCTAssertNil(callHeaders["Authorization"])
                }

            } catch {
                XCTFail("Couldn't make request \(endpoint.path)")
            }
        }
    }

    /// This tests to make sure every endpoint that has `requiresAccessToken = true`  to
    /// explicitly fail (with a specific error) if that token isn't in appConfiguration. If it is in appConfiguration, and network gives us the `200`, then it should succeed.
    func testAllEndpointAccessTokens() async {
        networkServiceResponse = .mock(data: emptyMock!, status: 200)
        appConfiguration = .mock(baseUrl: "www.google.com", accessToken: "43hug534h5g345")
        makeSut()

        for endpoint in Endpoint.allCases {

            appConfiguration = .mock(accessToken: nil)
            var tokenType: String? = nil
            if endpoint.requiresAccessToken {
                tokenType = appConfiguration.accessToken()
            }

            guard let _ = tokenType else {
                // No token necessary means this call should just succeed
                do {
                    let _: NoReply =  try await sut.call(endpoint: endpoint)
                } catch {
                    XCTFail("No token necessary for this request so shouldn't get an error \(endpoint.path)")
                }
                return
            }

            // Token is necessary here it means this call should gets fail. The NetworkServiceError.defaultError(let error) error
            do {
                let _: NoReply =  try await sut.call(endpoint: endpoint)
                XCTFail("Token is necessary for this request so it should gets an error \(endpoint.path)")
            } catch NetworkServiceError.defaultError(let error) {
                XCTAssertEqual(error.title, "messageError.default.title")
                XCTAssertEqual(error.message, "messageError.default.message")
            } catch {
                XCTFail("Should fail with dedefaultError \(endpoint.path) \(error)")
            }

            // Token is necessary here it means this call should gets fail. The NetworkServiceError.noAuthTokenInStorage error
            do {
                let _: NoReply =  try await sut.call(endpoint: endpoint, shouldReturnDefaultError: false)
                XCTFail("Token is necessary for this request so it should gets an error \(endpoint.path)")
            } catch NetworkServiceError.noAuthTokenInStorage {}
            catch {
                XCTFail("Should fail with NetworkServiceError.noAuthTokenInStorage \(endpoint.path) \(error)")
            }

            // Setting token so all calls shoul gets success
            appConfiguration = .mock(accessToken: "abc123")
            do {
                let _: NoReply =  try await sut.call(endpoint: endpoint)
            } catch {
                XCTFail("Couldn't make request \(endpoint.path)")
            }
        }
    }

    func testRetryOn401_Success() async {
        // When
        appConfiguration = .mock(baseUrl: "www.google.com", accessToken: "43hug534h5g345")

        var networkServiceResponses: [NetworkResponse] = [
            .mock(status: 401),
            .mock(data: emptyMock!, status: 200)
        ]

        let networkService: NetworkService = .testMock(
            appConfiguration: appConfiguration
        ) { _ in networkServiceResponses.removeFirst() }

        let responseExpectation = expectation(description: "API Callback")
        responseExpectation.expectedFulfillmentCount = 2
        networkService.setRetryOn401 {
            responseExpectation.fulfill()
            $0(.success(()))
        }

        do {
            let _: NoReply = try await networkService.call(endpoint: .popularMovies(page: 1))
            responseExpectation.fulfill()
        } catch {
            XCTFail("Sould not fail")
        }

        await fulfillment(of: [responseExpectation], timeout: 1.0)
    }

    func testRetryOn401_Failure() async {
        // When
        appConfiguration = .mock(baseUrl: "www.google.com", accessToken: "43hug534h5g345")

        let responseExpectation = expectation(description: "API Callback")
        responseExpectation.expectedFulfillmentCount = 2

        let networkService: NetworkService = .testMock(
            appConfiguration: appConfiguration
        ) { _ in .mock(status: 401) }


        networkService.setRetryOn401 {
            responseExpectation.fulfill()
            $0(.failure(NetworkServiceError.unhandledHTTPStatus(500, Data())))
        }

        do {
            let _: NoReply = try await networkService.call(endpoint: .popularMovies(page: 1))
            XCTFail("Sould not get success on the request")
        } catch {
            responseExpectation.fulfill()
        }

        await fulfillment(of: [responseExpectation], timeout: 1.0)
    }

    func testDecodeObjSuccess() async {
        // When
        networkServiceResponse = .mock(data: dummyMock!, status: 200)
        appConfiguration = .mock(baseUrl: "www.google.com", accessToken: "43hug534h5g345")
        makeSut()

        do {
            let _: Dummy = try await sut.call(endpoint: .popularMovies(page: 1))

        } catch {
            XCTFail("Sould not get success on the request")
        }
    }

    // MARK: - Error Hendler

    func testHandle400Error_WithDefaultError_EmptyResponse() async {
        // When
        networkServiceResponse = .mock(data: emptyMock!, status: 400)
        appConfiguration = .mock(baseUrl: "www.google.com", accessToken: "43hug534h5g345")
        makeSut()

        do {
            let _: NoReply = try await sut.call(endpoint: .popularMovies(page: 1))
            XCTFail("Sould not get success on the request")
        } catch NetworkServiceError.defaultError(let error){
            XCTAssertEqual(error.code, 400)
            XCTAssertEqual(error.title, "messageError.default.title")
            XCTAssertEqual(error.message, "messageError.default.message")

        } catch {
            XCTFail("Sould not get other errors type \(error)")
        }
    }

    func testHandle400Error_WithDefaultError() async {
        // When
        networkServiceResponse = .mock(data: defaultErrorMock!, status: 400)
        appConfiguration = .mock(baseUrl: "www.google.com", accessToken: "43hug534h5g345")
        makeSut()

        do {
            let _: NoReply = try await sut.call(endpoint: .popularMovies(page: 1))
            XCTFail("Sould not get success on the request")
        } catch NetworkServiceError.defaultError(let error){
            XCTAssertEqual(error.code, 400)
            XCTAssertEqual(error.title, "Oops... something went wrong")
            XCTAssertEqual(error.message, "Email or password invalid")

        } catch {
            XCTFail("Sould not get other errors type \(error)")
        }
    }

    func testHandle400Error_WithDefaultError_WrongErrorJson() async {
        // When
        networkServiceResponse = .mock(data: dummyMock!, status: 400)
        appConfiguration = .mock(baseUrl: "www.google.com", accessToken: "43hug534h5g345")
        makeSut()

        do {
            let _: NoReply = try await sut.call(endpoint: .popularMovies(page: 1))
            XCTFail("Sould not get success on the request")
        } catch NetworkServiceError.defaultError(let error){
            XCTAssertEqual(error.code, 400)
            XCTAssertEqual(error.title, "messageError.default.title")
            XCTAssertEqual(error.message, "messageError.default.message")

        } catch {
            XCTFail("Sould not get other errors type \(error)")
        }
    }

    func testHandle400Error_WithoutDefaultError_WrongErrorJson() async {
        // When
        networkServiceResponse = .mock(data: dummyMock!, status: 400)
        appConfiguration = .mock(baseUrl: "www.google.com", accessToken: "43hug534h5g345")
        makeSut()

        do {
            let _: NoReply = try await sut.call(endpoint: .popularMovies(page: 1), shouldReturnDefaultError: false)
            XCTFail("Sould not get success on the request")
        } catch let NetworkServiceError.unhandledHTTPStatus(status, data) {
            XCTAssertEqual(status, 400)
            XCTAssertEqual(data, dummyMock!)

        } catch {
            XCTFail("Sould not get other errors type \(error)")
        }
    }

    func testHandle500Error_WithDefaultError() async {
        // When
        networkServiceResponse = .mock(data: defaultErrorMock!, status: 500)
        appConfiguration = .mock(baseUrl: "www.google.com", accessToken: "43hug534h5g345")
        makeSut()

        do {
            let _: NoReply = try await sut.call(endpoint: .popularMovies(page: 1))
            XCTFail("Sould not get success on the request")
        } catch NetworkServiceError.defaultError(let error) {
            XCTAssertEqual(error.code, 500)
            XCTAssertEqual(error.title, "messageError.default.title")
            XCTAssertEqual(error.message, "messageError.default.message")

        } catch {
            XCTFail("Sould not get other errors type \(error)")
        }
    }

    func testHandle500Error_WithoutDefaultError() async {
        // When
        networkServiceResponse = .mock(data: defaultErrorMock!, status: 500)
        appConfiguration = .mock(baseUrl: "www.google.com", accessToken: "43hug534h5g345")
        makeSut()

        do {
            let _: NoReply = try await sut.call(endpoint: .popularMovies(page: 1), shouldReturnDefaultError: false)
            XCTFail("Sould not get success on the request")
        } catch NetworkServiceError.serverError(let statusCode){
            XCTAssertEqual(statusCode, 500)

        } catch {
            XCTFail("Sould not get other errors type \(error)")
        }
    }

    func testHandleDecodeResponseError_WithDefaultError() async {
        // When
        networkServiceResponse = .mock(data: defaultErrorMock!, status: 200)
        appConfiguration = .mock(baseUrl: "www.google.com", accessToken: "43hug534h5g345")
        makeSut()

        do {
            let _: Dummy = try await sut.call(endpoint: .popularMovies(page: 1))
            XCTFail("Sould not get success on the request")
        } catch NetworkServiceError.defaultError(let error) {
            XCTAssertEqual(error.code, 0)
            XCTAssertEqual(error.title, "messageError.default.title")
            XCTAssertEqual(error.message, "messageError.default.message")

        } catch {
            XCTFail("Sould not get other errors type \(error)")
        }
    }

    func testHandleDecoldeResponseError_WithoutDefaultError() async {
        // When
        networkServiceResponse = .mock(data: defaultErrorMock!, status: 200)
        appConfiguration = .mock(baseUrl: "www.google.com", accessToken: "43hug534h5g345")
        makeSut()

        do {
            let _: Dummy = try await sut.call(endpoint: .popularMovies(page: 1), shouldReturnDefaultError: false)
            XCTFail("Sould not get success on the request")
        } catch NetworkServiceError.jsonParsingFailure {}
        catch {
            XCTFail("Sould not get other errors type \(error)")
        }
    }

    // MARK: - Additional Settings

    @MainActor
    func testAppendHeader() async {
        // When
        networkServiceResponse = .mock(data: defaultErrorMock!, status: 200)
        appConfiguration = .mock(baseUrl: "www.google.com", accessToken: "43hug534h5g345")
        makeSut()

        let endpoint: Endpoint = .popularMovies(page: 1)

        do {
            let _: NoReply =  try await sut.call(endpoint: endpoint, additionalSettings: [.appendHeader([["test": "test1"], ["test2": "test3"]])])

            // Now we have to assert that the headers are correct
            guard let callHeaders = networkServiceRequest.allHTTPHeaderFields else {
                XCTFail("Couldn't headers on networkServiceRequest")
                return
            }

            XCTAssertEqual(callHeaders["Content-Type"], "application/json")
            XCTAssertEqual(callHeaders["Accept"], "application/json")

            XCTAssertEqual(callHeaders["test"], "test1")
            XCTAssertEqual(callHeaders["test2"], "test3")

        } catch {
            XCTFail("Couldn't make request \(endpoint.path)")
        }
    }

    func testOverrrideHeader() async {
        // When
        networkServiceResponse = .mock(data: defaultErrorMock!, status: 200)
        appConfiguration = .mock(baseUrl: "www.google.com", accessToken: "43hug534h5g345")
        makeSut()

        let endpoint: Endpoint = .popularMovies(page: 1)

        do {
            let _: NoReply =  try await sut.call(endpoint: endpoint, additionalSettings: [.overrideHeader([["test": "test1"], ["test2": "test3"]])])

            // Now we have to assert that the headers are correct
            guard let callHeaders = networkServiceRequest.allHTTPHeaderFields else {
                XCTFail("Couldn't headers on networkServiceRequest")
                return
            }

            XCTAssertNil(callHeaders["Content-Type"])
            XCTAssertNil(callHeaders["Accept"])

            XCTAssertEqual(callHeaders["test"], "test1")
            XCTAssertEqual(callHeaders["test2"], "test3")

        } catch {
            XCTFail("Couldn't make request \(endpoint.path)")
        }
    }

    func testChangeTimeoutInterval() async {
        // When
        networkServiceResponse = .mock(data: defaultErrorMock!, status: 200)
        appConfiguration = .mock(baseUrl: "www.google.com", accessToken: "8s0f78sdf79sd7f89")
        makeSut()

        let endpoint: Endpoint = .popularMovies(page: 1)

        do {
            let _: NoReply =  try await sut.call(endpoint: endpoint, additionalSettings: [.setTimeOut(100)])

            XCTAssertEqual(networkServiceRequest.timeoutInterval, 100)

        } catch {
            XCTFail("Couldn't make request \(endpoint.path)")
        }
    }
}

extension Endpoint: CaseIterable {
    public static var allCases: [Endpoint] = {
        [
            .popularMovies(page: 1)
        ]
    }()
}
