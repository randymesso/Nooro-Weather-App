import SwiftUI


struct CustomSearchBar: View
{
    @Binding var text: String
    let placeholder: String
    let onSubmit: () -> Void
    
    var body: some View
    {
        HStack
        {
            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: 15))
                .frame(height: 26)
                .onSubmit(onSubmit)
            
            Button(action: onSubmit) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
