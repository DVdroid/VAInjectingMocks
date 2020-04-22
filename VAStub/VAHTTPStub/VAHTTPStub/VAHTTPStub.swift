//
//  VAHTTPStub.swift
//  VAHTTPStub
//
//  Created by Vikash Anand on 21/04/20.
//  Copyright © 2020 Vikash Anand. All rights reserved.
//

import Foundation

final public class VAHTTPStub {

    class public func stubRequest(request: URLRequest,
                    withData responseData: Data?,
                                   result: @escaping (Data?, URLResponse?, Error?) -> Void) {

        let urlSessionMock = URLSessionMock()
        urlSessionMock.data = responseData
        guard let url = request.url else { return }
        urlSessionMock.response = HTTPURLResponse(url: url,
                                           statusCode: 200,
                                          httpVersion: nil,
                                         headerFields: ["Content-Type": "application/json"])

        let task = urlSessionMock.dataTask(with: request.url!) { (data, response, error) in
            result(data, response, nil)
        }

        task.resume()
    }
}
