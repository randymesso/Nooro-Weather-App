import SwiftUI


// MARK: - Services
protocol WeatherService
{
    func fetchWeather(for city: String) async throws -> WeatherResponse
}

class LiveWeatherService: WeatherService {
    private let apiKey: String
    private let baseURL = "https://api.weatherapi.com/v1"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func fetchWeather(for city: String) async throws -> WeatherResponse {
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/current.json?key=\(apiKey)&q=\(encodedCity)") else {
            throw WeatherError.invalidCity
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw WeatherError.networkError
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                let decoder = JSONDecoder()
                return try decoder.decode(WeatherResponse.self, from: data)
            case 400:
                throw WeatherError.invalidCity
            case 401, 403:
                throw WeatherError.serverError
            default:
                throw WeatherError.networkError
            }
        } catch is DecodingError {
            throw WeatherError.noWeatherData
        } catch let error as WeatherError {
            throw error
        } catch {
            throw WeatherError.networkError
        }
    }
}
