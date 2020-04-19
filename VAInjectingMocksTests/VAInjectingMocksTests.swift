//
//  VAInjectingMocksTests.swift
//  VAInjectingMocksTests
//
//  Created by Vikash Anand on 14/04/20.
//  Copyright © 2020 Vikash Anand. All rights reserved.
//

import XCTest
@testable import VAInjectingMocks
import ToDosStub

class VAInjectingMocksTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDataFetch() {

        class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
            func resume() {}
            func cancel() {}
        }

        class URLSessionMock: URLSessionProtocol {

            var lastUrl: URL?
            var data: Data?

            func dataTask(with url: URL,
                          completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
                self.lastUrl = url
                let response = HTTPURLResponse(url: url,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
                completionHandler(self.data, response, nil)
                return URLSessionDataTaskMock()
            }
        }

        //Given
        let urlString = "https://jsonplaceholder.typicode.com/todos/1"
        guard let url = URL(string: urlString) else {
            XCTFail("Invalid url")
            return
        }

        let mainBundle = Bundle.main
        let pathToStubFrameWork = mainBundle.builtInPlugInsURL?.appendingPathComponent("ToDosStub.framework")
        if let pathToStubFrameWork = pathToStubFrameWork, let bundle = Bundle(url: pathToStubFrameWork) {

            guard let dataUrl = bundle.url(forResource: "posts",
                                           withExtension: "json") else { return }
            let data = try? Data(contentsOf: dataUrl)

            let session = URLSessionMock()
            session.data = data
            let expectation = XCTestExpectation(description: "Network opertion")

            //When
            NetworkManager.loadData(from: url,
                                    using: session,
                                    responseType: ToDos.self) { (result) in
                                        guard let toDoObject = try? result.get() else {
                                            XCTFail("Invalid response")
                                            return
                                        }

                                        //Then
                                        XCTAssertEqual(toDoObject.userId, 1)
                                        XCTAssertEqual(toDoObject.id, 1)
                                        XCTAssertEqual(toDoObject.title, "delectus aut autem")
                                        XCTAssertEqual(toDoObject.completed, false)
                                        expectation.fulfill()
            }

            wait(for: [expectation], timeout: 5.0)

        } else {
            XCTFail("Stub framework not found.")
        }
    }

}
