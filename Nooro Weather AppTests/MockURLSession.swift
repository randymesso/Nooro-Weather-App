import XCTest
@testable import Nooro_Weather_App


// MARK: - Mock URLSession
class MockURLSession: URLSession
{
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
}
