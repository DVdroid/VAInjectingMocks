//
//  VAStubManager.swift
//  VAStub
//
//  Created by Vikash Anand on 21/04/20.
//  Copyright © 2020 Vikash Anand. All rights reserved.
//

import Foundation
import VAHTTPStub

final public class VAStubManager {

    class public func data(forResource name: String, withExtension type: String) -> Data? {

        let mainBundle = Bundle.main
        guard let path = mainBundle.builtInPlugInsURL?.appendingPathComponent("VAStub.framework"),
            let bundle = Bundle(url: path),
            let url = bundle.url(forResource: name, withExtension: type),
            let data = try? Data(contentsOf: url) else { return nil }

        return data
    }

    class public func stubRequest(forUrl url: URL,
                                  forResource name: String,
                                  withExtension type: String,
                                  result: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let request = URLRequest(url: url)

        let data = VAStubManager.data(forResource: name, withExtension: type)
        VAHTTPStub.stubRequest(request: request,
                               withData: data) { (data, response, error) in
                                result(data, response, error)
        }
    }
}
