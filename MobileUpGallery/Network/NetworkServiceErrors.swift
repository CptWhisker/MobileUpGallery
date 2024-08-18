import Foundation

enum NetworkServiceError: Error {
    case dataTaskError
    case responseError
    case dataFetchError
    case decodingError
}
