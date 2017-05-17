import Vapor
import Auth
import HTTP

let drop = Droplet()

let auth = AuthMiddleware(user :User.self)

drop.middleware.append(auth)

drop.post("login") { request in
    
    guard let userName = request.json?["userName"]?.string,
          let password = request.json?["password"]?.string
        else {
            throw Abort.badRequest
    }
    
    let credentials = UserCredentials(userName: userName, password: password)
    
    try request.auth.login(credentials)
    
    return try! JSON(node: ["message":"Logged in check the authentication cookie"])
}

drop.post("register") { request in
    
    guard let userName = request.json?["userName"]?.string,
          let password = request.json?["password"]?.string
        else {
            throw Abort.badRequest
    }
    
    let credential = UserCredentials(userName: userName, password: password)
    
    let user = try User.register(credentials: credential)
    
    return try JSON(node :user)
    
}


drop.run()
