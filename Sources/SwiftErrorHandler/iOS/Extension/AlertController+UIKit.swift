//
//  AlertController+UIKit.swift
//  SwiftErrorHandler
//
//  Created by Stefan Renne on 31/12/2019.
//

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit

extension AlertControllerStyle {
    func build() -> UIAlertController.Style {
        switch self {
        case .actionSheet:
            return .actionSheet
        case .alert:
            return .alert
        }
    }
}

extension AlertActionStyle {
    func build() -> UIAlertAction.Style {
        switch self {
        case .default:
            return .default
        case .cancel:
            return .cancel
        }
    }
}

extension AlertController {
    func build() -> UIAlertController {
        let preferredStyle: UIAlertController.Style = self.preferredStyle.build()
        let controller: UIAlertController = UIAlertController(title: self.title, message: self.message, preferredStyle: preferredStyle)

        self.actions
            .map({ $0.build() })
            .forEach { (action) in
                controller.addAction(action)
            }

        return controller
    }
}

extension AlertAction {
    func build() -> UIAlertAction {
        let style: UIAlertAction.Style = self.style.build()
        return UIAlertAction(title: self.title, style: style, handler: { [weak self] _ in
            guard let `self` = self else { return }
            self.handler?(self)
        })
    }
}
#endif
