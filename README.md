# SwiftErrorHandler

[![Swift 5.0](https://img.shields.io/badge/swift-5.0-orange.svg?style=flat)](https://swift.org)
[![Travis Status](https://travis-ci.org/stefanrenne/SwiftErrorHandler.svg?branch=master)](https://travis-ci.org/stefanrenne/SwiftErrorHandler)
[![Maintainability](https://api.codeclimate.com/v1/badges/13a3613bc81ed631e9e2/maintainability)](https://codeclimate.com/github/stefanrenne/SwiftErrorHandler/maintainability)
[![CocoaPods Version Badge](https://img.shields.io/cocoapods/v/SwiftErrorHandler.svg)](https://cocoapods.org/pods/SwiftErrorHandler)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License Badge](https://img.shields.io/cocoapods/l/SwiftErrorHandler.svg)](LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/SwiftErrorHandler.svg?style=flat)](http://cocoapods.org/pods/SwiftErrorHandler)

SwiftErrorHandler enables expressing complex error handling logic with a few lines of code using a memorable fluent API.


## Installation

### CocoaPods

```
pod 'SwiftErrorHandler', '~> 5.0'
```

### Carthage

```
github "stefanrenne/SwiftErrorHandler" ~> 5.0
```

### Swift Package Manager (SPM)

```
import PackageDescription

let package = Package(
  name: "My App",
    dependencies: [
      .package(url: "https://github.com/stefanrenne/SwiftErrorHandler.git", from: "5.0.0")
    ]
)
```


## Usage

Let's say we're building a account based iOS app that can throw errors in the networking layer.

We need to:

### Setup a default ErrorHandler once

The default ErrorHandler will contain the error handling logic that is common across your application that you don't want to duplicate. You can create a factory that creates it so that you can get new instance with common handling logic from anywhere in your app.

```swift
extension ErrorHandler {
  class func `default`(for view: ErrorHandlerView) -> ErrorHandler {
    return ErrorHandler(for: view)
      .on(error: .code(NSURLErrorTimedOut), then: .present(alert: ConfirmableAlert(title: "Timeout occurred", confirmTitle: "Retry", confirmAction: { error in print("retry network call") })))
      .on(error: .type(NetworkError.noInternet), then: .present(alert: ConfirmableAlert(title: "Did you turn off the internet?", confirmTitle: "No")))
      .on(error: .type(NetworkError.logout), then: .present(alert: RejectableAlert(title: "Are you sure you want to logout?", confirmTitle: "Yes", rejectTitle: "No")))
      .always(.perform(action: AnalyticsService.track))
      .onNoMatch(.present(alert: ConfirmableAlert(title: "Something went wrong", confirmTitle: "Ok")))
    }
}
```

### Use the default handler to handle common cases

Often the cases the default handler knows about will be good enough.

```swift
do {
  try saveStatus()
} catch {
  ErrorHandler.default(for: self).handle(error: error)
}
```

### Customize the error handler when needed.

In cases where extra context is available you can add more cases or override the ones provided already.

For example in a LoginViewController

```swift
class LoginViewController: UIViewController {
    
  private lazy var errorHandler = ErrorHandler.default(for: self)
    .on(error: .type(NetworkError.authenticate), then: .perform(action: startAuthentication))
        
  func performLogin() {
    do {
      try login()
    } catch {
      errorHandler.handle(error: error)
    }
  }
    
  private func startAuthentication(for error: Error, onCompleted: OnErrorHandled) {
    print("start authentication ...")
    onCompleted?()
    return true
  }      
}
```


### Bonus: RxSwift Support

```swift
let errorHandler = ErrorHandler.default(for: self)
Observable<User>
  .error(NetworkError.authenticate)
  .subscribe(onNext: { result in
      print("User loggedin")
    },
    onError: errorHandler.handle)
  .disposed(by: disposeBag)
```


### Bonus: Result Support

```swift
let errorHandler = ErrorHandler.default(for: self)
let result: Result<User, NetworkError> = .failure(NetworkError.authenticate)
let user: User? = result.get(onError: errorHandler)
```


## Customization options

### The way actions are performed for errors

- Performs actions for specific errors

	`errorHandler.on(error: .code(404), then: .present(Alert))`

- Performs actions when no specific error matcher can be found 

	`errorHandler.onNoMatch(.present(Alert))`

- Actions that need to be performed for all errors

	`errorHandler.always(.perform(action: analyticsService.track))`


### Error Matchers

**Match on specific error type**

`errorHandler.on(error: .type(NetworkError.authenticate), then: .doNothing)`

#### Match on NSError code

``errorHandler.on(error: .code(404), then: .doNothing)`

#### Match on NSError domain

`errorHandler.on(error: .domain("remote"), then: .doNothing)`

#### Custom matching

```
extension ErrorMatcher {
    static func onCustomMatch() -> ErrorMatcher {
        .init(matcher: { error in 
            ...
            return true 
        })
    }
}

.on(error: .onCustomMatch()), then: .doNothing)
```

### Error Handling

#### Do nothing

It mainly exists to make documentation & unit tests easier to understand.

`errorHandler.on(error: .code(404), then: .doNothing)`


#### Present Alert

The Alert is presented on the View provided in the ErrorHandler init

`errorHandler.on(error: .code(404), then: .present(alert: ErrorAlert))`

By default there are two alert types you can present:

- **ConfirmableAlert**: An alert with one action button
- **RejectableAlert**: An alert with two action buttons
 
Would you like to use different alerts?

1. Create a struct that conforms to the **ErrorAlert** protocol
2. Implement the function that builds your custom UIAlertController 
`func build(for error: Error, onCompleted: OnErrorHandled) -> UIAlertController`
3. Make sure the optional `onCompleted` completionblock has been performed in all `UIAlertAction` completion blocks

#### Custom Action

The only limitation is your mind.

`errorHandler.on(error: .code(404), then: .perform(action: CustomActionHandler)`

The **CustomActionHandler** provides the `Error` and an optional `onCompleted` completionblock that needs to be executed when your custom action has been performed.


#### Implementing the ErrorHandler outside the ViewController

In larger apps it makes sense to implement the ErrorHandler in a different class than the ViewController. To make this work you need to provide a view on which alerts can be presented. This can be done by conforming to the ErrorHandlerView protocol.

```swift
public protocol ErrorHandlerView {
  func present(alert: UIAlertController)
}

extension UIViewController: ErrorHandlerView {
  public func present(alert: UIAlertController) {
    present(alert, animated: true, completion: nil)
  }
}

```


## Contribute?

**Build your xcode project using the Swift Package Manager**
 
```
swift package generate-xcodeproj --xcconfig-overrides ./Sources/ios.xcconfig
```


**Quick checklist summary before submitting a PR**

- 🔎 Make sure tests are added or updated to accomodate your changes. We do not accept any addition that comes without tests. When possible, add tests to verify bug fixes and prevent future regressions.
- 📖 Check that you provided a CHANGELOG entry documenting your changes (except for documentation improvements)
- 👌 Verify that tests pass
- 👍 Push it!


## Why?

When designing for errors, we usually need to:

1. have a **default** handler for **expected** errors
// i.e. network, db errors etc.
2. handle **specific** errors **in a custom manner** given **the context**  of where and when they occur
// i.e. a network error while uploading a file, invalid login
3. have **unspecific** handlers that get executed on every error
// i.e. log errors to Fabric or any other analytics service
4. have a **catch-all** handler for **unknown** errors
// i.e. errors we don't have custom handling for
5. keep our code **DRY**

Swift has a well thought error handling model that balances between convenience ([automatic propagation](https://github.com/apple/swift/blob/master/docs/ErrorHandlingRationale.rst#automatic-propagation)) and clarity-safety ([Typed propagation](https://github.com/apple/swift/blob/master/docs/ErrorHandlingRationale.rst#id3), [Marked propagation](https://github.com/apple/swift/blob/master/docs/ErrorHandlingRationale.rst#id4)). As a result, the compiler warns of errors that need to be handled, while making it relatively easy to propagate errors and handle them higher up the stack.

However, even with this help from the language, achieving the goals listed above in an **ad-hoc** manner in an application of a reasonable size can lead to a lot of **boilerplate** which is **tedious** to write and reason about. Because of this friction, developers quite often choose to swallow errors or handle them all in the same generic way.

This library addresses these issues by providing an abstraction to define flexible error handling rules with an opinionated, fluent API.
