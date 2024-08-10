import AppConfiguration
import Foundation

public typealias NetworkResponse = Result<(Data, HTTPURLResponse), Error>

extension NetworkService {
    /// Mock constructor for `NetworkService`
    ///
    /// Usage:
    /// ```
    /// class Mock: XCTestCase {
    ///     var networkServiceResponse: NetworkResponse!
    ///     var networkService = NetworkService.mock(
    ///         appConfiguration: appConfiguration,
    ///         mockValueProvider: { self.networkServiceResponse }
    ///     )
    ///
    ///     func testThing() {
    ///         // this sets the mock value that the service will respond with
    ///         let path = Bundle.module.path(forResource: "configs", ofType: "json")
    ///         // try using autocomplete on `networkServiceResponse` values to see the other useful mock constructors
    ///         // this one takes the bundle filepath for a JSON resource, and does all the decoding and stuff for us.
    ///         networkServiceResponse = try .mockFromFile(dataPath: path, status: 200)
    ///
    ///            let expectation = expectation(description: "Correct response")
    ///            networkDependentService.doAPICall { response in
    ///                switch response {
    ///                case .success(let returnValue):
    ///                    XCTAssertEqual(returnValue, expectedValue)
    ///                case .error(let error):
    ///                    XCTFail()
    ///                }
    ///                expectation.fulfill()
    ///            }
    ///
    ///            waitForExpectations(timeout: 1.0)
    ///     }
    /// }
    ///
    /// // Here's another way you could use this flexible interface, for handling the results of many calls in a row.
    /// // It will pull items from the queue one by one (you could extend the impl to `XCTFail()` if it attempts to
    /// // pull too many items from the queue)
    /// var mockValueQueue: [NetworkResponse] = [...]
    /// var networkService = NetworkService.mock(
    ///     appConfiguration: appConfiguration,
    ///        mockValueProvider: { mockValueQueue.removeFirst() }
    ///    )
    /// ```
    ///
    /// - Parameters:
    ///   - appConfiguration: AppConfiguration dependency
    ///   - notifiersService: NotifiersService dependency
    ///   - mockValueProvider: A mechanism through which mock values can be passed to the network service.
    /// - Returns: A NetworkService mock object
    public static func mock(
        appConfiguration: EnvironmentConfigurationService,
        mockValueProvider: @escaping () -> NetworkResponse
    ) -> NetworkService {
        .init(
            appConfiguration: appConfiguration,
            baseNetworkRequest: { _ in
                switch mockValueProvider() {
                case .success(let value): return value
                case .failure(let error): throw error
                }
            }
        )
    }
}
