import UIKit

final class VideosNetworkService {
    // MARK: - Properties
    private let session = URLSession.shared
    private var offset: Int = 0
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
        
    // MARK: - Public Methods
    func fetchVideos(completion: @escaping (Result<[Video], Error>) -> Void) {
            guard let accessToken = AccessTokenStorage.shared.accessToken else {
                print("ERROR")
                return
            }
            
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "api.vk.com"
            urlComponents.path = "/method/video.get"
            
            urlComponents.queryItems = [
                URLQueryItem(name: "owner_id", value: "-128666765"),
                URLQueryItem(name: "access_token", value: accessToken),
                URLQueryItem(name: "v", value: "5.131"),
                URLQueryItem(name: "offset", value: "\(offset)"),
                URLQueryItem(name: "count", value: "5")
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
                                
                do {
                    let response = try self.decoder.decode(VKVideosResonse.self, from: data)
                    completion(.success(response.response.items))
                } catch {
                    completion(.failure(NetworkServiceError.decodingError))
                }
            }
            
            task.resume()
        }
    
    func increaseOffset() {
        offset += 5
    }
}
