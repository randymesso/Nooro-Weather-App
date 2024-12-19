import XCTest
@testable import Nooro_Weather_App


class MockCityStorage: CityStorage {
    var savedCity: String?
    var mockSavedCity: String?
    
    func saveCity(_ city: String) {
        savedCity = city
    }
    
    func loadCity() -> String? {
        return mockSavedCity
    }
}
