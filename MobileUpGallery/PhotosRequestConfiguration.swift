import Foundation

struct PhotosRequestConfiguration {
    let scheme: String
    let host: String
    let path: String
    let ownerID: String
    let albumID: String
    let version: String
    let count: Int
    
    static var mobileUpWall = PhotosRequestConfiguration(
        scheme: "https",
        host: "api.vk.com",
        path: "/method/photos.get",
        ownerID: "-128666765",
        albumID: "wall",
        version: "5.199",
        count: 10
    )
    
    static var mobileUpOffice = PhotosRequestConfiguration(
        scheme: "https",
        host: "api.vk.com",
        path: "/method/photos.get",
        ownerID: "-128666765",
        albumID: "266276915",
        version: "5.199",
        count: 10
    )
    
    init(
        scheme: String,
        host: String,
        path: String,
        ownerID: String,
        albumID: String,
        version: String,
        count: Int
    ) {
        self.scheme = scheme
        self.host = host
        self.path = path
        self.ownerID = ownerID
        self.albumID = albumID
        self.version = version
        self.count = count
    }
}
