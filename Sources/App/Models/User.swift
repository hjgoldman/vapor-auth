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
