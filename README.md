# SwiftErrorHandler

[![Swift 5.0](https://img.shields.io/badge/swift-5.0-orange.svg?style=flat)](https://swift.org)
[![CocoaPods Version Badge](https://img.shields.io/cocoapods/v/SwiftErrorHandler.svg)](https://cocoapods.org/pods/SwiftErrorHandler)
[![License Badge](https://img.shields.io/cocoapods/l/SwiftErrorHandler.svg)](LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/SwiftErrorHandler.svg?style=flat)](http://cocoapods.org/pods/SwiftErrorHandler)

SwiftErrorHandler enables expressing complex error handling logic with a few lines of code using a memorable fluent API.


## Installation

### CocoaPods

```
pod 'SwiftErrorHandler', '~> 5.0'
```

## Usage

Let's say we're building a messaging iOS app that uses both the network and a local database.

We need to:

### Setup a default ErrorHandler once

The default ErrorHandler will contain the error handling logic that is common across your application and you don't want to duplicate. You can create a factory that creates it so that you can get new instance with the common handling logic from anywhere in your app.

```swift
extension ErrorHandler {
  class func `default`(for view: ErrorHandlerView) -> ErrorHandler {
    return ErrorHandler(for: view)
      .if(error: .has(code: NSURLErrorTimedOut), then: .present(alert: ConfirmableAlert(title: "Timeout occurred", confirmTitle: "Retry", confirmAction: { error in print("retry network call") })))
      .if(error: .isEqual(to: CustomError.noInternet), then: .present(alert: ConfirmableAlert(title: "Did you turn off the internet?", confirmTitle: "No")))
      .if(error: .isEqual(to: CustomError.logout), then: .present(alert: RejectableAlert(title: "Are you sure you want to logout?", confirmTitle: "Yes", rejectTitle: "No")))
      .else(then: .present(alert: ConfirmableAlert(title: "Something went wrong", confirmTitle: "Ok")))
    }
}
```

The only required attribute is a view to present alerts on, by default all UIViewControllers conform to the ErrorHandlerView protocol. But if in your implemented architecture a different class is resposible for presenting views it is very easy to conform to this protocol.

```swift
extension UIViewController: ErrorHandlerView { }
```



### Use the default handler to handle common cases

Often the cases the default handler knows about will be good enough.

```swift
do {
  try saveStatus()
} catch {
  ErrorHandler.default.handle(error: error)
}
```

### Customize the error handler when needed.

In cases where extra context is available you can add more cases or override the ones provided already.

For example in a LoginViewController

```swift
class LoginViewController: UIViewController {
    
  private lazy var errorHandler = ErrorHandler.default(for: self)
    .if(error: .isEqual(to: CustomError.authenticate), then: .perform(action: startAuthentication))
        
  func performLogin() {
    do {
      try login()
    } catch {
      errorHandler.handle(error: error)
    }
  }
    
  private func startAuthentication(for error: Error, onHandled: OnErrorHandled) -> Bool {
    print("start authentication ...")
    onHandled?()
    return true
  }      
}
```

### Bonus: RxSwift Support

```swift
class LoginViewController: UIViewController {

  private let disposeBag = DisposeBag()
    
  private lazy var errorHandler = ErrorHandler.default(for: self)
    .if(error: .isEqual(to: CustomError.authenticate), then: .perform(action: startAuthentication))
        
  func performLogin() {
    
    Observable<User>
      .error(CustomError.authenticate)
      .subscribe(onNext: { result in
          print("User loggedin")
        },
        onError: errorHandler.handle)
      .disposed(by: disposeBag)
  }
    
  private func startAuthentication(for error: Error, onHandled: OnErrorHandled) -> Bool {
    print("start authentication ...")
    onHandled?()
    return true
  }   
        
}
```


## Why?

When designing for errors, we usually need to:

1. have a **default** handler for **expected** errors
// i.e. network, db errors etc.
2. handle **specific** errors **in a custom manner** given **the context**  of where and when they occur
// i.e. network error while uploading a file, invalid login
3. have a **catch-all** handler for **unknown** errors
// i.e. errors we don't have custom handling for
4. keep our code **DRY**

Swift's has a very well thought error handling model keeping balance between convenience ([automatic propagation](https://github.com/apple/swift/blob/master/docs/ErrorHandlingRationale.rst#automatic-propagation)) and clarity-safety ([Typed propagation](https://github.com/apple/swift/blob/master/docs/ErrorHandlingRationale.rst#id3), [Marked propagation](https://github.com/apple/swift/blob/master/docs/ErrorHandlingRationale.rst#id4)). As a result, the compiler serves as a reminder of errors that need to be handled and at the same type it is relatively easy to propagate errors and handle them higher up the stack.

However, even with this help from the language, achieving the goals listed above in an **ad-hoc** manner in an application of a reasonable size can lead to a lot of **boilerplate** which is **tedious** to write and reason about. Because of this friction developers quite often choose to swallow errors or handle them all in the same generic way.

This library addresses these issues by providing an abstraction over defining flexible error handling rules with an opinionated fluent API.
