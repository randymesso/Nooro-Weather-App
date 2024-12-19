enum WeatherError: Error
{
    case invalidCity
    case networkError
    case serverError
    case noWeatherData
    case noCitySaved
    
    var userMessage: String
    {
        switch self
        {
        case .invalidCity:
            return "City not found. Please try another location."
        case .networkError:
            return "Unable to connect. Please check your internet connection."
        case .serverError:
            return "Unable to fetch weather data. Please try again later."
        case .noWeatherData:
            return "No weather data available for this location."
        case .noCitySaved:
            return "No city selected. Search for a city to get started."
        }
    }
}
