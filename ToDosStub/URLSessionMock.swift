//
//  URLSessionMock.swift
//  VAInjectingMocks
//
//  Created by Vikash Anand on 19/04/20.
//  Copyright © 2020 Vikash Anand. All rights reserved.
//

import Foundation

public class URLSessionMock: URLSessionProtocol {

    class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
        func resume() {}
        func cancel() {}
    }

    public var lastUrl: URL?
    public var data: Data?

    public init() {}
    public func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        self.lastUrl = url
        let urlResonse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        completionHandler(self.data, urlResonse, nil)

        return URLSessionDataTaskMock()
    }
}
