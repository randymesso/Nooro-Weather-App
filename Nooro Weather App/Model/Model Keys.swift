import Foundation

struct WeatherResponse: Codable
{
    let location: Location
    let current: Current
}

struct Location: Codable
{
    let name: String
    let region: String
    let country: String
}

struct Current: Codable
{
    let tempC: Double
    let condition: Condition
    let humidity: Int
    let uv: Double
    let feelslikeC: Double
    
    enum CodingKeys: String, CodingKey
    {
        case tempC = "temp_c"
        case condition
        case humidity
        case uv
        case feelslikeC = "feelslike_c"
    }
}

struct Condition: Codable
{
    let text: String
    let icon: String
}



