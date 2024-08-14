import Foundation

struct AuthConfiguration {
    let scheme: String
    let host: String
    let path: String
    let clientID: String
    let redirectURI: String
    let display: String
    let responseType: String
    let navigationActionPath: String
    
    static var standart = AuthConfiguration(
        scheme: "https",
        host: "oauth.vk.com",
        path: "/authorize",
        clientID: "52136813",
        redirectURI: "https://oauth.vk.com/blank.html",
        display: "mobile",
        responseType: "token",
        navigationActionPath: "/blank.html"
    )
    
    init(
        scheme: String,
        host: String,
        path: String,
        clientID: String,
        redirectURI: String,
        display: String,
        responseType: String,
        navigationActionPath: String
    ) {
        self.scheme = scheme
        self.host = host
        self.path = path
        self.clientID = clientID
        self.redirectURI = redirectURI
        self.display = display
        self.responseType = responseType
        self.navigationActionPath = navigationActionPath
    }
}
