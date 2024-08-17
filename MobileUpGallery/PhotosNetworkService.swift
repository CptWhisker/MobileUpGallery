import UIKit

final class PhotosNetworkService {
    // MARK: - Properties
    private let session = URLSession.shared
    private let configuration: PhotosRequestConfiguration = .mobileUpOffice
    private var totalPhotosCount: Int?
    private var offset: Int = 0
    private lazy var decoder: JSONDecoder = {
        return JSONDecoder()
    }()
    
    // MARK: - Fetching Photos
    func fetchPhotos(completion: @escaping (Result<[Photo], Error>) -> Void) {
        guard let accessToken = AccessTokenStorage.shared.accessToken else {
            print("ERROR")
            return
        }
        
        if let totalPhotosCount, offset >= totalPhotosCount {
            return
        }
        
        guard let request = generateRequest(with: accessToken) else {
            print("ERROR")
            return
        }
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { return }
            
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
            
            do {
                let response = try self.decoder.decode(VKPhotosResponse.self, from: data)
                
                if self.totalPhotosCount == nil {
                    self.totalPhotosCount = response.response.count
                }
                
                completion(.success(response.response.items))
            } catch {
                completion(.failure(NetworkServiceError.decodingError))
            }
        }
        
        task.resume()
    }
    
    private func generateRequest(with accessToken: String) -> URLRequest? {
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
            return nil
        }
        
        return URLRequest(url: url)
    }
    
    //MARK: - Public Methods
    func increaseOffset() {
        offset += configuration.count
    }
}
