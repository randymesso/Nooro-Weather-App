import XCTest
@testable import Nooro_Weather_App


class LiveWeatherServiceTests: XCTestCase {
    var sut: LiveWeatherService! // system under test
    var mockSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        sut = LiveWeatherService(apiKey: "test-api-key")
    }
    
    override func tearDown() {
        sut = nil
        mockSession = nil
        super.tearDown()
    }
    
    func testURLConstructionWithSpecialCharacters() async {
        // Given
        let city = "New York"
        
        // When/Then
        do {
            _ = try await sut.fetchWeather(for: city)
        } catch WeatherError.invalidCity {
            XCTFail("URL construction failed for city with spaces")
        } catch {
            // Other errors are expected in this test as we're not providing mock responses
        }
    }
    
    // MARK: - Response Handling Tests
    func testSuccessfulWeatherResponse() async throws {
        // Given
        let jsonResponse = """
        {
            "location": {
                "name": "London",
                "region": "City of London",
                "country": "UK"
            },
            "current": {
                "temp_c": 20.0,
                "condition": {
                    "text": "Sunny",
                    "icon": "sunny.png"
                },
                "humidity": 50,
                "uv": 5.0,
                "feelslike_c": 21.0
            }
        }
        """.data(using: .utf8)!
        
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.weatherapi.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        // Use URLProtocol mock or dependency injection to return this response
        // This is a placeholder for the actual implementation
    }
    
//    func testInvalidCityResponse() async {
//        // Given
//        let city = ""
//        
//        // When
//        do {
//            _ = try await sut.fetchWeather(for: city)
//            XCTFail("Expected invalid city error")
//        } catch {
//            // Then
//            XCTAssertEqual(error as? WeatherError, .invalidCity)
//        }
//    }
    
    // MARK: - Error Handling Tests
    func testNetworkError() async {
        // Test network error handling
        // Implementation depends on your mocking strategy
    }
    
    func testDecodingError() async {
        // Test invalid JSON response
        // Implementation depends on your mocking strategy
    }
    
    func testServerError() async {
        // Test 401/403 response codes
        // Implementation depends on your mocking strategy
    }
}
