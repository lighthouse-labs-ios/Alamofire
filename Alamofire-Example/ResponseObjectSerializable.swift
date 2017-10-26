//
//  ResponseObjectSerializable.swift
//  Alamofire-Example
//
//  Created by Kareem Sabri on 2017-10-26.
//  Copyright © 2017 Kareem Sabri. All rights reserved.
//

import Foundation
import Alamofire

enum BackendError: Error {
    case network(error: Error) // Capture any underlying Error from the URLSession API
    case dataSerialization(error: Error)
    case jsonSerialization(error: Error)
    case xmlSerialization(error: Error)
    case objectSerialization(reason: String)
}

protocol ResponseObjectSerializable {
    init?(response: HTTPURLResponse, representation: Any)
}

protocol Requestable: class, AnyObject, ResponseObjectSerializable {
    var path: String { get }
    func serialize() -> Parameters
    func copy(u: Self)
}

extension DataRequest {
    func responseObject<T: ResponseObjectSerializable>(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<T>) -> Void)
        -> Self
    {
        let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
            guard error == nil else { return .failure(BackendError.network(error: error!)) }
            
            let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonResponseSerializer.serializeResponse(request, response, data, nil)
            
            guard case let .success(jsonObject) = result else {
                return .failure(BackendError.jsonSerialization(error: result.error!))
            }
            
            guard let response = response, let responseObject = T(response: response, representation: jsonObject) else {
                return .failure(BackendError.objectSerialization(reason: "JSON could not be serialized: \(jsonObject)"))
            }
            
            return .success(responseObject)
        }
        
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}

extension Requestable {
    func save(completionHandler: @escaping () -> Void)  {
        Alamofire.request("https://lighthouse-todos.herokuapp.com/api/v1/\(path)", method: .post, parameters: serialize(), encoding: JSONEncoding.default).responseObject { (data: DataResponse<Self>) in
                debugPrint(data)
                self.copy(u: data.value!)
                completionHandler()
        }
    }
}
