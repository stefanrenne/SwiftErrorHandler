//
//  ErrorHandlerView+UIKit.swift
//  SwiftErrorHandler
//
//  Created by Stefan Renne on 31/12/2019.
//

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit

extension UIViewController: ErrorHandlerView {
    public func present(alert: AlertController) {
        present(alert.build(), animated: true, completion: nil)
    }
}
#endif
