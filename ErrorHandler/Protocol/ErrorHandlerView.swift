//
//  ErrorHandlerView.swift
//  ErrorHandler
//
//  Created by Stefan Renne on 19/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import UIKit

extension UIViewController: ErrorHandlerView { }

public protocol ErrorHandlerView {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}
