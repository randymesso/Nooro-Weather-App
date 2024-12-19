import SwiftUI

struct WeatherDetailRow: View
{
    let title: String
    let value: String
    let titleFont: CGFloat
    let valueFont: CGFloat
    
    var body: some View {
        VStack {
            Text(title)
                .foregroundColor(.secondary)
                .font(.system(size: titleFont))
            
            Text(value)
                .fontWeight(.medium)
                .font(.system(size: valueFont))
        }
    }
}
