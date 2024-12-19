import Foundation

extension LiveWeatherServiceTests {
    func makeSuccessResponse(for url: URL) -> HTTPURLResponse {
        return HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
    }
    
    func makeErrorResponse(for url: URL, statusCode: Int) -> HTTPURLResponse {
        return HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }
    
    func makeWeatherData() -> Data {
        return """
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
    }
}
