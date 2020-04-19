//
//  URLSession+Extension.swift
//  VAInjectingMocks
//
//  Created by Vikash Anand on 19/04/20.
//  Copyright © 2020 Vikash Anand. All rights reserved.
//

import Foundation

public protocol URLSessionProtocol {
    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}


extension URLSession: URLSessionProtocol {
    public func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask
    }
}
