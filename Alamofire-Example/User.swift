//
//  User.swift
//  Alamofire-Example
//
//  Created by Kareem Sabri on 2017-10-26.
//  Copyright © 2017 Kareem Sabri. All rights reserved.
//

import Foundation
import Alamofire

class User: Requestable, CustomStringConvertible {
    var path: String = "/users"
    
    func serialize() -> Parameters {
        return [
            "email": self.email,
            "password": self.password
        ]
    }
    
    func copy(u: User) {
        self.id = u.id
        self.email = u.email
    }
    
    var id: Int?
    var email: String = ""
    var password: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var token: String = ""
    
    init(email: String, password: String) {
        self.id = nil
        self.email = email
        self.password = password
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        guard
            let representation = representation as? [String: Any],
            let id = representation["id"] as? Int,
            let email = representation["email"] as? String
            else { return nil }
        
        self.id = id
        self.email = email
    }
    
    var description: String {
        return "User: { id: \(id) }"
    }
    
    func save(completionHandler: @escaping () -> Void)  {
        Alamofire.request("https://lighthouse-todos.herokuapp.com/api/v1/users", method: .post, parameters: [
            "email": email,
            "password": password
            ], encoding: JSONEncoding.default).responseObject { (data: DataResponse<User>) in
                debugPrint(data)
                let u = data.value!
                self.id = u.id
                self.email = u.email
                self.password = u.password
                completionHandler()
        }
    }
}
