import UIKit

struct ErrorResponse: Decodable {
    
}
final class PhotosNetworkService {
    // MARK: - Properties
    private let session = URLSession.shared
    private let configuration: PhotosRequestConfiguration = .mobileUpOffice
    private var offset: Int = 0
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    // MARK: - Public Methods
    func fetchPhotos(completion: @escaping (Result<[Photo], Error>) -> Void) {
        guard let accessToken = AccessTokenStorage.shared.accessToken else {
            print("ERROR")
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = configuration.scheme
        urlComponents.host = configuration.host
        urlComponents.path = configuration.path
        
        urlComponents.queryItems = [
            URLQueryItem(name: "owner_id", value: configuration.ownerID),
            URLQueryItem(name: "album_id", value: configuration.albumID),
            URLQueryItem(name: "access_token", value: accessToken),
            URLQueryItem(name: "v", value: configuration.version),
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "count", value: "\(configuration.count)")
        ]
        
        guard let url = urlComponents.url else {
            print("ERROR")
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(NetworkServiceError.dataTaskError))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode < 200 || response.statusCode >= 300 {
                completion(.failure(NetworkServiceError.responseError))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkServiceError.dataFetchError))
                return
            }
            
            print(String(data: data, encoding: .utf8))
            
            do {
                let response = try self.decoder.decode(VKPhotosResponse.self, from: data)
                completion(.success(response.response.items))
            } catch {
                completion(.failure(NetworkServiceError.decodingError))
            }
        }
        
        task.resume()
    }
    
    func increaseOffset() {
        offset += configuration.count
    }
}
