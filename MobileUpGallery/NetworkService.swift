import UIKit

final class NetworkService<T: Decodable> {
    // MARK: - Properties
    private let session: URLSession
    private let configuration: RequestConfigurationProtocol
    private var totalItemsCount: Int?
    private var offset: Int = 0
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, configuration: RequestConfigurationProtocol, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.configuration = configuration
        self.decoder = decoder
    }
    
    // MARK: - Fetching Photos
    func fetchItems(completion: @escaping (Result<[T], Error>) -> Void) {
        if let totalItemsCount, offset >= totalItemsCount {
            return
        }
        
        guard let accessToken = AccessTokenStorage.shared.accessToken,
              let request = generateRequest(with: accessToken) else {
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
                let decodedResponse = try self.decoder.decode(GenericResponse<T>.self, from: data)
                
                if self.totalItemsCount == nil {
                    print(decodedResponse.response.count)
                    self.totalItemsCount = decodedResponse.response.count
                }
                
                completion(.success(decodedResponse.response.items))
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
        urlComponents.queryItems = configuration.queryItems + [
            URLQueryItem(name: "access_token", value: accessToken),
            URLQueryItem(name: "offset", value: "\(offset)")
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
