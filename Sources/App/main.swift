import Vapor
import Auth
import HTTP

let drop = Droplet()

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
