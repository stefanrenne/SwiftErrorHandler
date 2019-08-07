//
//  ViewController.swift
//  Demo
//
//  Created by Stefan Renne on 19/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import UIKit
import ErrorHandler
import RxSwift

enum CustomError: Error {
    case noInternet
    case logout
    case authenticate
}

enum RandomError: Error {
    case one
    case two
}

fileprivate extension Error {
    var reflectedString: String {
        return String(reflecting: self)
    }
}

class ViewController: UIViewController {
    
    private lazy var errorHandler = ErrorHandler.default(for: self)
        .if(error: .isEqual(to: CustomError.authenticate), then: .perform(action: startAuthentication))
        .if(error: .matches({ $0 is RandomError }), then: .present(alert: ConfirmableAlert(title: "RandomError occurred", confirmTitle: "Ok")))
    
    private let disposeBag = DisposeBag()
    
    private func startAuthentication(for error: Error, onHandled: OnErrorHandled) -> Bool {
        print("start authentication ...")
        onHandled?()
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Observable<String>.error(RandomError.two)
            .subscribe(onNext: { result in
                    print("Success: " + result)
                },
                onError: errorHandler.handle)
            .disposed(by: disposeBag)
        
//        errorHandler.handle(error: RandomError.two, onHandled: { print("finished!") })
//        errorHandler.handle(error: CustomError.authenticate)
    }
    
    private func error1() {
        
    }
    

}

extension ErrorHandler {
    class func `default`(for view: ErrorHandlerView) -> ErrorHandler {
        return ErrorHandler(for: view)
            .if(error: .has(code: NSURLErrorTimedOut), then: .present(alert: ConfirmableAlert(title: "Timeout occurred", confirmTitle: "Retry")))
            .if(error: .isEqual(to: CustomError.noInternet), then: .present(alert: ConfirmableAlert(title: "Did you turn off the internet?", confirmTitle: "No")))
            .if(error: .isEqual(to: CustomError.logout), then: .present(alert: RejectableAlert(title: "Are you sure you want to logout?", confirmTitle: "Yes", rejectTitle: "No", confirmAction: { error in print("Time to logout...") })))
            .else(then: .present(alert: ConfirmableAlert(title: "Something went wrong", confirmTitle: "Ok")))
    }
}
