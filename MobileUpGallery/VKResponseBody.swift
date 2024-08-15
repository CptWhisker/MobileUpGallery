import Foundation

// MARK: - Photos Response
struct VKPhotosResponse: Decodable {
    let response: Photos
}

struct Photos: Decodable {
    let items: [Photo]
}

struct Photo: Decodable {
    let date: Int
    let sizes: [PhotoSize]
    
    var thumbURL: String? {
        guard let thumb = sizes.first(where: { $0.type == "q" }) else {
            return sizes.first?.url
        }
        return thumb.url
    }
    
    var largeURL: String? {
        return sizes.last?.url
    }
}

struct PhotoSize: Decodable {
    let type: String
    let url: String
}
