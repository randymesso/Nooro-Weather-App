import SwiftUI

enum NetworkError: Error
{
    case invalidURL
    case invalidResponse
    case decodingError
}
