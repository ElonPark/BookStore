//
//  BaseViewController.swift
//  BookStore
//
//  Created by Elon on 2021/11/17.
//

import UIKit

class BaseUIViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("deinit: \(type(of: self))")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Color.background
    }
}
