import UIKit

final class PhotosNetworkService {
    private let session = URLSession.shared
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
        
        func fetchPhotos(completion: @escaping (Result<[Photo], Error>) -> Void) {
            guard let accessToken = AccessTokenStorage.shared.accessToken else {
                print("ERROR")
                return
            }
            
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "api.vk.com"
            urlComponents.path = "/method/photos.get"
            
            urlComponents.queryItems = [
                URLQueryItem(name: "owner_id", value: "-128666765"),
                URLQueryItem(name: "album_id", value: "wall"),
                URLQueryItem(name: "access_token", value: accessToken),
                URLQueryItem(name: "v", value: "5.131")
            ]
            
            guard let url = urlComponents.url else {
                print("ERROR")
                return
            }
            
            let request = URLRequest(url: url)
            
            let task = session.dataTask(with: request) { data, response, error in
                if let error {
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
                
//                print(String(decoding: data, as: UTF8.self))
                
                do {
                    let response = try self.decoder.decode(VKPhotosResponse.self, from: data)
                    completion(.success(response.response.items))
                } catch {
                    completion(.failure(NetworkServiceError.decodingError))
                }
            }
            
            task.resume()
        }
}

// MARK: - Network Service Errors
enum NetworkServiceError: Error {
    case dataTaskError
    case responseError
    case dataFetchError
    case decodingError
}
