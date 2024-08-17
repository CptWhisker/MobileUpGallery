import Foundation

// MARK: - Photos Response
struct VKPhotosResponse: Decodable {
    let response: Photos
}

struct Photos: Decodable {
    let count: Int
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
    
    var formattedDate: String {
        let date = Date(timeIntervalSince1970: TimeInterval(self.date))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        return dateFormatter.string(from: date)
    }
}

struct PhotoSize: Decodable {
    let type: String
    let url: String
}

// MARK: - Videos Response
struct VKVideosResonse: Decodable {
    let response: Videos
}

struct Videos: Decodable {
    let count: Int
    let items: [Video]
}

struct Video: Decodable {
    let title: String
    let player: String
    let image: [PreviewImage]
    
    var previewURL: String? {
        return image.last?.url
    }
}

struct PreviewImage: Decodable {
    let url: String
}
