import SwiftUI

@main
struct Nooro_Weather_AppApp: App {
    // Create the view model at app level to maintain state
    @StateObject private var viewModel = WeatherViewModel(
        weatherService: LiveWeatherService(apiKey: "fc53a02d0a264dc181793753241712"),
        cityStorage: UserDefaultsCityStorage()
    )
    
    // Scene phase to detect app state changes
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .onChange(of: scenePhase) { newPhase in
                    switch newPhase {
                    case .active:
                        // Reload when app becomes active
                        Task {
                            await viewModel.reloadCurrentCity()
                        }
                    default:
                        break
                    }
                }
                .task {
                    // Initial load when app launches
                    await viewModel.reloadCurrentCity()
                }
        }
    }
}
