import Foundation

struct VideoRequestConfiguration {
    let scheme: String
    let host: String
    let path: String
    let ownerID: String
    let version: String
    let count: Int
    
    static var standard = VideoRequestConfiguration(
        scheme: "https",
        host: "api.vk.com",
        path: "/method/video.get",
        ownerID: "-128666765",
        version: "5.199",
        count: 5
    )
    
    init(
        scheme: String,
        host: String,
        path: String,
        ownerID: String,
        version: String,
        count: Int
    ) {
        self.scheme = scheme
        self.host = host
        self.path = path
        self.ownerID = ownerID
        self.version = version
        self.count = count
    }
}

extension VideoRequestConfiguration: RequestConfigurationProtocol {
    var queryItems: [URLQueryItem] {
        return [
            URLQueryItem(name: "owner_id", value: ownerID),
            URLQueryItem(name: "v", value: version),
            URLQueryItem(name: "count", value: "\(count)")
        ]
    }
}
