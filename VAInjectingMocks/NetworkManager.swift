//
//  NetworkManager.swift
//  VAInjectingMocks
//
//  Created by Vikash Anand on 14/04/20.
//  Copyright © 2020 Vikash Anand. All rights reserved.
//

import Foundation
import VAHTTPStub
import VAStub

final class NetworkManager {

    class func loadData<T:Decodable>(from url: URL,
                                     using session: URLSessionProtocol = URLSession.shared,
                                     responseType type: T.Type,
                                     result: @escaping (Result<T, Error>) -> Void) {

        if ProcessInfo.processInfo.arguments.contains("--enableStubs") {

            VAStubManager.stubRequest(forUrl: url,
                                      forResource: "posts",
                                      withExtension: "json") { (data, response, error) in
                                        guard let data = data, error == nil else { return }
                                        do {
                                            let response = try JSONDecoder().decode(type, from: data)
                                            result(.success(response))
                                        } catch {
                                            result(.failure(error))
                                        }
            }

        } else {

            let task = session.dataTask(with: url) { (data, response, error) in

                guard let data = data, error == nil else { return }
                do {
                    let response = try JSONDecoder().decode(type, from: data)
                    result(.success(response))
                } catch {
                    result(.failure(error))
                }
            }
            task.resume()

        }

    }
}
