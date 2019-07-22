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
    
    private let disposeBag = DisposeBag()
    
    private lazy var errorHandler = ErrorHandler.default(for: self)
        .on(.error(CustomError.authenticate), do: .custom(startAuthentication))
        .on(.match({ $0 is RandomError }), do: .custom({ onHandled in print("win"); onHandled?(); return true }))
    
    private func startAuthentication(onHandled: OnErrorHandled) -> Bool {
        print("start authentication ...")
        onHandled?()
        //Authentication was successfull
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Observable<String>.error(RandomError.two)
            .subscribe(onNext: { result in
                print("Success: " + result)
            }, onError: errorHandler.handle)
            .disposed(by: disposeBag)
        
//        errorHandler.handle(error: RandomError.two, onHandled: { print("finished!") })
//        errorHandler.handle(error: CustomError.authenticate)
    }

}

extension ErrorHandler {
    class func `default`(for view: ErrorHandlerView) -> ErrorHandler {
        return ErrorHandler(for: view)
            .on(.error(CustomError.noInternet), do: .alert(ConfirmableAlert(title: "oeps something went wrong", confirmTitle: "OK")))
            .on(.error(CustomError.logout), do: .alert(RejectableAlert(title: "are you sure you want to logout?", confirmTitle: "Yes", rejectTitle: "No")))
            .else(do: .alert(ConfirmableAlert(title: "Unhandled Error", confirmTitle: "OK")))
    }
}
