import SwiftUI

struct ContentView: View
{
    @StateObject private var viewModel: WeatherViewModel
    @State private var searchText = ""
    @State private var isSearchActive = false
    
    init(viewModel: WeatherViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View
    {
        NavigationView
        {
            ZStack
            {
                Color(hex: "#FFFFFF")
                    .ignoresSafeArea()
                
                VStack(spacing: 0)
                {
                    //Always present search bar
                    CustomSearchBar(
                        text: $searchText,
                        placeholder: "Search Location",
                        onSubmit: {
                            Task {
                                await viewModel.searchWeather(for: searchText)
                                isSearchActive = true
                            }
                        }
                    )
                    .padding()
                    .background(Color(.systemBackground))
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .padding()
                    }
                    
                    // Content area
                    GeometryReader { geometry in
                        if isSearchActive
                        {
                            // Show search results
                            SearchResultsView(
                                searchText: searchText,
                                weather: viewModel.searchResultWeather,
                                onCitySelected: {
                                    viewModel.selectCity()
                                    isSearchActive = false
                                    searchText = ""
                                }
                            )
                        }
                        else
                        {
                            // Show main weather view or empty state
                            if let weather = viewModel.weatherData
                            {
                                ScrollView
                                {
                                    WeatherView(weather: weather)
                                }
                            }
                            else
                            {
                                // Center empty state in the remaining space
                                VStack(spacing: 12)
                                {
                                    Text("No City Selected")
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundColor(Color(hex: "#2C2C2C"))
                                    
                                    Text("Please Search For A City")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(Color(hex: "#2C2C2C"))
                                }
                                .frame(width: geometry.size.width, height: geometry.size.height)
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK") {
                    viewModel.error = nil
                }
            } message: {
                Text(viewModel.error?.userMessage ?? "An unknown error occurred.")
            }
        }
    }
}
