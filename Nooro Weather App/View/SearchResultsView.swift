import SwiftUI

struct SearchResultsView: View {
    let searchText: String
    let weather: WeatherResponse?
    let onCitySelected: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            if let weather = weather {
                // Only show the weather card if weather data exists
                Button {
                    onCitySelected()
                } label: {
                    HStack(spacing: 16)
                    {
                        VStack(alignment: .leading, spacing: 4)
                        {
                            Text(weather.location.name)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color(hex: "#2C2C2C"))
                            HStack
                            {
                                Text("\(Int(weather.current.tempC))")
                                    .font(.system(size: 60, weight: .bold))
                                    .foregroundColor(Color(hex: "#2C2C2C"))
                                Text("°")
                                    .foregroundColor(Color(hex: "#2C2C2C"))
                                    .padding(.bottom, 30)
                            }
                            
                        }
                        
                        Spacer()
                        
                        AsyncImage(url: URL(string: "https:" + weather.current.condition.icon)) { image in
                            image
                                .resizable()
                                .frame(width: 83, height: 67)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .buttonStyle(PlainButtonStyle())
            }
            // Show nothing if the search doesn't return a city
            
            Spacer()
        }
        .padding()
    }
}
