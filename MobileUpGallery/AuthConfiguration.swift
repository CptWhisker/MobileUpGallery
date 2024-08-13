import Foundation

struct AuthConfiguration {
    let urlComponentsScheme: String
    let urlComponentsHost: String
    let urlComponentsPath: String
    let clientID: String
    let redirectURI: String
    let display: String
    let responseType: String
    let navigationActionPath: String
    
    static var standart = AuthConfiguration(
        urlComponentsScheme: "https",
        urlComponentsHost: "oauth.vk.com",
        urlComponentsPath: "/authorize",
        clientID: "52136813",
        redirectURI: "https://oauth.vk.com/blank.html",
        display: "mobile",
        responseType: "token",
        navigationActionPath: "/blank.html"
    )
    
    init(
        urlComponentsScheme: String,
        urlComponentsHost: String,
        urlComponentsPath: String,
        clientID: String,
        redirectURI: String,
        display: String,
        responseType: String,
        navigationActionPath: String
    ) {
        self.urlComponentsScheme = urlComponentsScheme
        self.urlComponentsHost = urlComponentsHost
        self.urlComponentsPath = urlComponentsPath
        self.clientID = clientID
        self.redirectURI = redirectURI
        self.display = display
        self.responseType = responseType
        self.navigationActionPath = navigationActionPath
    }
}
