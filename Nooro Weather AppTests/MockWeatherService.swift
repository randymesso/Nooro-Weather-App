import XCTest
@testable import Nooro_Weather_App


// MARK: - Mock Services
class MockWeatherService: WeatherService
{
    var shouldThrowError = false
    var errorToThrow: WeatherError?
    var mockWeatherResponse: WeatherResponse?
    
    func fetchWeather(for city: String) async throws -> WeatherResponse {
        if shouldThrowError {
            throw errorToThrow ?? WeatherError.serverError
        }
        return mockWeatherResponse ?? WeatherResponse(
            location: Location(name: city, region: "Test Region", country: "Test Country"),
            current: Current(
                tempC: 20.0,
                condition: Condition(text: "Sunny", icon: "sunny.png"),
                humidity: 50,
                uv: 5.0,
                feelslikeC: 21.0
            )
        )
    }
}
