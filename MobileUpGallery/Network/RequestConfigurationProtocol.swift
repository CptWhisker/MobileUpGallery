import Foundation

protocol RequestConfigurationProtocol {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var count: Int { get }
    var queryItems: [URLQueryItem] { get }
}
