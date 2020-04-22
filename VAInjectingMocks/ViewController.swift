//
//  ViewController.swift
//  VAInjectingMocks
//
//  Created by Vikash Anand on 14/04/20.
//  Copyright © 2020 Vikash Anand. All rights reserved.
//

import UIKit
import VAStub

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        makeAPICall()
    }

    private func makeAPICall() {

        let urlString = "https://jsonplaceholder.typicode.com/todos/1"
        guard let url = URL(string: urlString) else { return }

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

