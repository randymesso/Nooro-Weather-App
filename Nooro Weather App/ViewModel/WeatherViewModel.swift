import SwiftUI

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherResponse?
    @Published var searchResultWeather: WeatherResponse?
    @Published var isLoading = false
    @Published var error: WeatherError?
    @Published var showError = false
    
    private let weatherService: WeatherService
    private let cityStorage: CityStorage
    
    init(weatherService: WeatherService, cityStorage: CityStorage)
    {
        self.weatherService = weatherService
        self.cityStorage = cityStorage
        loadSavedCity()
    }
    
    private func loadSavedCity() {
        if let savedCity = cityStorage.loadCity() {
            Task {
                await fetchWeather(for: savedCity)
            }
        }
    }
    
    func fetchWeather(for city: String) async {
        isLoading = true
        error = nil
        
        do {
            weatherData = try await weatherService.fetchWeather(for: city)
            cityStorage.saveCity(city)
        } catch let error as WeatherError {
            self.error = error
            self.showError = true
        } catch {
            self.error = .serverError
            self.showError = true
        }
        
        isLoading = false
    }
    
    func searchWeather(for city: String) async {
        guard !city.isEmpty else {
            error = .invalidCity
            showError = true
            return
        }
        
        isLoading = true
        error = nil
        
        do {
            searchResultWeather = try await weatherService.fetchWeather(for: city)
        } catch let error as WeatherError {
            self.error = error
            self.showError = true
        } catch {
            self.error = .serverError
            self.showError = true
        }
        
        isLoading = false
    }
    
    func selectCity() {
        if let searchWeather = searchResultWeather {
            weatherData = searchWeather
            cityStorage.saveCity(searchWeather.location.name)
        }
        searchResultWeather = nil
    }
    
    func reloadCurrentCity() async {
        guard let savedCity = cityStorage.loadCity() else {
            error = .noCitySaved
            showError = true
            return
        }
        
        await fetchWeather(for: savedCity)
    }
}


