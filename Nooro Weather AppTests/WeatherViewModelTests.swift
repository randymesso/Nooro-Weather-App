import XCTest
@testable import Nooro_Weather_App


@MainActor
class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!
    var mockWeatherService: MockWeatherService!
    var mockCityStorage: MockCityStorage!
    
    override func setUp() {
        super.setUp()
        mockWeatherService = MockWeatherService()
        mockCityStorage = MockCityStorage()
        viewModel = WeatherViewModel(
            weatherService: mockWeatherService,
            cityStorage: mockCityStorage
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockWeatherService = nil
        mockCityStorage = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    func testInitialState() {
        XCTAssertNil(viewModel.weatherData)
        XCTAssertNil(viewModel.searchResultWeather)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
        XCTAssertFalse(viewModel.showError)
    }
    
    // MARK: - Fetch Weather Tests
    func testFetchWeatherSuccess() async {
        let expectedCity = "London"
        await viewModel.fetchWeather(for: expectedCity)
        
        XCTAssertNotNil(viewModel.weatherData)
        XCTAssertEqual(viewModel.weatherData?.location.name, expectedCity)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
        XCTAssertEqual(mockCityStorage.savedCity, expectedCity)
    }
    
    func testFetchWeatherFailure() async {
        mockWeatherService.shouldThrowError = true
        mockWeatherService.errorToThrow = .networkError
        
        await viewModel.fetchWeather(for: "London")
        
        XCTAssertNil(viewModel.weatherData)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.error as? WeatherError, .networkError)
        XCTAssertTrue(viewModel.showError)
    }
    
    // MARK: - Search Weather Tests
    func testSearchWeatherWithEmptyCity() async {
        await viewModel.searchWeather(for: "")
        
        XCTAssertNil(viewModel.searchResultWeather)
        XCTAssertEqual(viewModel.error as? WeatherError, .invalidCity)
        XCTAssertTrue(viewModel.showError)
    }
    
    func testSearchWeatherSuccess() async {
        await viewModel.searchWeather(for: "Paris")
        
        XCTAssertNotNil(viewModel.searchResultWeather)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
    }
    
    func testSearchWeatherFailure() async {
        mockWeatherService.shouldThrowError = true
        mockWeatherService.errorToThrow = .invalidCity
        
        await viewModel.searchWeather(for: "InvalidCity")
        
        XCTAssertNil(viewModel.searchResultWeather)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.error as? WeatherError, .invalidCity)
        XCTAssertTrue(viewModel.showError)
    }
    
    // MARK: - Select City Tests
    func testSelectCityWithSearchResult() {
        let testWeather = WeatherResponse(
            location: Location(name: "Paris", region: "Test", country: "Test"),
            current: Current(
                tempC: 25.0,
                condition: Condition(text: "Clear", icon: "clear.png"),
                humidity: 45,
                uv: 6.0,
                feelslikeC: 26.0
            )
        )
        viewModel.searchResultWeather = testWeather
        
        viewModel.selectCity()
        
        XCTAssertEqual(viewModel.weatherData?.location.name, testWeather.location.name)
        XCTAssertEqual(mockCityStorage.savedCity, testWeather.location.name)
        XCTAssertNil(viewModel.searchResultWeather)
    }
    
    func testSelectCityWithNoSearchResult() {
        viewModel.searchResultWeather = nil
        
        viewModel.selectCity()
        
        XCTAssertNil(viewModel.weatherData)
        XCTAssertNil(mockCityStorage.savedCity)
    }
    
    // MARK: - Reload Current City Tests
    func testReloadCurrentCitySuccess() async {
        mockCityStorage.mockSavedCity = "Tokyo"
        
        await viewModel.reloadCurrentCity()
        
        XCTAssertNotNil(viewModel.weatherData)
        XCTAssertEqual(viewModel.weatherData?.location.name, "Tokyo")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
    }
    
    func testReloadCurrentCityWithNoSavedCity() async {
        mockCityStorage.mockSavedCity = nil
        
        await viewModel.reloadCurrentCity()
        
        XCTAssertNil(viewModel.weatherData)
        XCTAssertEqual(viewModel.error as? WeatherError, .noCitySaved)
        XCTAssertTrue(viewModel.showError)
    }
}
