import SwiftUI

// MARK: - Storage
protocol CityStorage {
    func saveCity(_ city: String)
    func loadCity() -> String?
}

class UserDefaultsCityStorage: CityStorage {
    private let defaults = UserDefaults.standard
    private let cityKey = "savedCity"
    
    func saveCity(_ city: String) {
        defaults.set(city, forKey: cityKey)
    }
    
    func loadCity() -> String? {
        defaults.string(forKey: cityKey)
    }
}
