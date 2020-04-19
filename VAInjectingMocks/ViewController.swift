//
//  ViewController.swift
//  VAInjectingMocks
//
//  Created by Vikash Anand on 14/04/20.
//  Copyright © 2020 Vikash Anand. All rights reserved.
//

import UIKit
import ToDosStub

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        makeAPICall()
    }

    private func makeAPICall() {

        let urlString = "https://jsonplaceholder.typicode.com/todos/1"
        guard let url = URL(string: urlString) else { return }


        if ProcessInfo.processInfo.arguments.contains("--enableStubs") {
            let mainBundle = Bundle.main
            let pathToStubFrameWork = mainBundle.builtInPlugInsURL?.appendingPathComponent("ToDosStub.framework")
            if let pathToStubFrameWork = pathToStubFrameWork, let bundle = Bundle(url: pathToStubFrameWork) {

                guard let dataUrl = bundle.url(forResource: "posts",
                                               withExtension: "json") else { return }
                let data = try? Data(contentsOf: dataUrl)

                let session = URLSessionMock()
                session.data = data

                NetworkManager.loadData(from: url,
                                        using: session,
                                        responseType: ToDos.self) { (result) in
                                            switch result {
                                            case .success(let responseData):
                                                print(responseData)
                                            case .failure(let error):
                                                print(error)
                                            }
                }

            } else {
                assertionFailure("Stub framework not found.")
            }
        } else {

            NetworkManager.loadData(from: url,
                                    responseType: ToDos.self) { (result) in
                                        switch result {
                                        case .success(let responseData):
                                            print(responseData)
                                        case .failure(let error):
                                            print(error)
                                        }
            }
        }

    }
    
}

