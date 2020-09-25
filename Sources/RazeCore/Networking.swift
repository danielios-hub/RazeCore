//
//  Networking.swift
//  RazeCore
//
//  Created by Daniel Gallego Peralta on 24/09/2020.
//

import Foundation

protocol NetworkSession {
    func get(from url: URL, completionHandler: @escaping (Data?, Error?) -> Void)
}

extension URLSession: NetworkSession {
    func get(from url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
        let task = dataTask(with: url) { data, _, error in
            completionHandler(data, error)
        }
        task.resume()
    }
}

extension RazeCore {
    public class Networking {
        
        /// Responsible for handling all networking calls
        /// - Warning: Must create before using any public APIs
        public class Manager {
            
            public init() {}
            
            internal var session : NetworkSession = URLSession.shared
            
            /// Cals to the live to retrieve Data from a specific location
            /// - Parameters:
            ///   - url: the location you wish to fetch data on
            ///   - completionHandler: Return a result object
            public func loadData(from url: URL, completionHandler: @escaping (NetworkResult<Data>) -> Void) {
                session.get(from: url) { (data, error) in
                    let result = data.map(NetworkResult<Data>.success) ?? .failure(error)
                    completionHandler(result)
                }
            }
        }
        
    }
    
    public enum NetworkResult<Value> {
        case success(Value)
        case failure(Error?)
    }
}
