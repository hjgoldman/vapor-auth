//
//  User.swift
//  vapor-auth
//
//  Created by Hayden Goldman on 5/17/17.
//
//

import Foundation
import Vapor
import Auth

//usering this class because we are not actully using a real DB 
class Store {
    static var users = [User]()
}

class UserCredentials : Credentials {
    
    var userName :String
    var password :String
    
    init(userName :String, password :String) {
        self.userName = userName
        self.password = password
    }
    
}

class User : Model {
    
    var id: Node?
    var userName :String
    var password :String
    
    required init(node: Node, in context: Context) throws {
        self.id = node
        self.userName = try node.extract("userName")
        self.password = try node.extract("password")
    }
    
    init(userName :String, password :String ) {
        self.userName = userName
        self.password = password
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "userName":self.userName,
            "password":self.password,
            "id":self.id
            ])
    }
    
    static func prepare(_ database: Database) throws {
    }
    
    static func revert(_ database: Database) throws {
    }
    
}

extension User : Auth.User {
    
    static func authenticate(credentials: Credentials) throws -> Auth.User {
        
        let user :User?
        
        switch credentials {
        case let userCredentials as UserCredentials:
            user = Store.users.first { u in
                return u.userName == userCredentials.userName && u.password == userCredentials.password
            }
            
        case let identifier as Identifier:
            let id = identifier.id.string
            
            user = Store.users.first { u in
                return u.id?.string == id
            }
        default:
            throw Abort.custom(status: .badRequest, message: "Invalid credentials")
        }
        
        
        guard let persistedUser = user else {
            throw Abort.custom(status: .badRequest, message: "User does not exist")
        }
        
        return persistedUser
    }
    
    static func register(credentials: Credentials) throws -> Auth.User {
        
        let userCredentials = credentials as! UserCredentials
        
        let user = User(userName: userCredentials.userName,
                        password: userCredentials.password)
        
        let duplicateUser = Store.users.contains { u in
            return u.userName == user.userName
        }
        
        if duplicateUser {
            throw Abort.custom(status: .conflict, message: "User already exist!")
        }
        
        user.id = Node(UUID().uuidString)
        
        Store.users.append(user)
        
        return user
    }
    
}





























