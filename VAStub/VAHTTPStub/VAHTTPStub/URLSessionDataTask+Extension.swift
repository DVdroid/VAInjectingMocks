//
//  URLSessionDataTask+Extension.swift
//  VAInjectingMocks
//
//  Created by Vikash Anand on 19/04/20.
//  Copyright © 2020 Vikash Anand. All rights reserved.
//

import Foundation

public protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
