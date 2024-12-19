import SwiftUI


struct WeatherView: View
{
    let weather: WeatherResponse
    
    var body: some View
    {
        VStack(spacing: 0)
        {
            HStack
            {
                Spacer()
                
                AsyncImage(url: URL(string: "https:" + weather.current.condition.icon)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .clipped()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 150, height: 130)
                
                Spacer()
            }
            
            HStack(spacing: 0)
            {
                Text(weather.location.name)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(Color(hex: "#2C2C2C"))
                
                Image("Arrow-Title")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44) 
                    .foregroundColor(Color(hex: "#2C2C2C"))
                    .padding(.top, 5)
            }
            .padding(.bottom, 24)
            
            HStack
            {
                Text("\(Int(weather.current.tempC))")
                    .font(.system(size: 70, weight: .bold))
                    .foregroundColor(Color(hex: "#2C2C2C"))
                Text("°")
                    .foregroundColor(Color(hex: "#2C2C2C"))
                    .padding(.bottom, 40)
            }
            .padding(.bottom, 34)
            
            HStack(spacing: 56)
            {
                WeatherDetailRow(title: "Humidity", value: "\(weather.current.humidity)%", titleFont: 12, valueFont: 15)
                WeatherDetailRow(title: "UV", value: String(format: "%.1f", weather.current.uv), titleFont: 12, valueFont: 15)
                WeatherDetailRow(title: "Feels Like", value: "\(Int(weather.current.feelslikeC))°C", titleFont: 8, valueFont: 15)
            }
            .padding(19)
            .background(Color(hex: "#F2F2F2"))
            .foregroundStyle(.secondary)
            .cornerRadius(10)
            .frame(width: 274, height: 75)
        }
        .padding()
    }
}
