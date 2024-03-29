![](Images/Header.png)

![](https://img.shields.io/badge/swift-5.3-orange.svg)
![](https://img.shields.io/github/release/netguru/ResponseDetective.svg)
![](https://img.shields.io/badge/carthage-compatible-green.svg)
![](https://img.shields.io/badge/cocoapods-compatible-green.svg)
![](https://img.shields.io/badge/spm-compatible-green.svg)
![](https://img.shields.io/badge/license-MIT-blue.svg)

**ResponseDetective** is a non-intrusive framework for intercepting any outgoing requests and incoming responses between your app and your server for debugging purposes.

## Requirements

ResponseDetective is written in **Swift 5.3** and supports **iOS 9.0+**, **macOS 10.10+** and **tvOS 9.0+**.

## Usage

Incorporating ResponseDetective in your project is very simple – it all comes down to just two steps:

### Step 1: Enable interception

For ResponseDetective to work, it needs to be added as a middleman between your `(NS)URLSession` and the Internet. You can do this by registering the provided `URLProtocol` class in your session's `(NS)URLSessionConfiguration.protocolClasses`, or use a shortcut method:

```objc
// Objective-C

NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
[RDTResponseDetective enableInConfiguration:configuration];
```

```swift
// Swift

let configuration = URLSessionConfiguration.default
ResponseDetective.enable(inConfiguration: configuration)
```

Then, you should use that configuration with your `(NS)URLSession`:

```objc
// Objective-C

NSURLSession *session = [[NSURLSession alloc] initWithConfiguration:configuration];
```

```swift
// Swift

let session = URLSession(configuration: configuration)
```

Or, if you're using [AFNetworking](https://github.com/AFNetworking/AFNetworking)/[Alamofire](https://github.com/Alamofire/Alamofire) as your networking framework, integrating ResponseDetective comes down to just initializing your `AFURLSessionManager`/`Manager` with the above `(NS)URLSessionConfiguration`:

```objc
// Objective-C (AFNetworking)

AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
```

```swift
// Swift (Alamofire)

let manager = Alamofire.SessionManager(configuration: configuration)
```

And that's all!

### Step 2: Profit

Now it's time to perform the actual request:

```objc
// Objective-C

NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://httpbin.org/get"]];
[[session dataTaskWithRequest:request] resume];
```

```swift
// Swift

let request = URLRequest(URL: URL(string: "http://httpbin.org/get")!)
session.dataTask(with: request).resume()
```

Voilà! 🎉 Check out your console output:

```none
<0x000000000badf00d> [REQUEST] GET https://httpbin.org/get
 ├─ Headers
 ├─ Body
 │ <none>

<0x000000000badf00d> [RESPONSE] 200 (NO ERROR) https://httpbin.org/get
 ├─ Headers
 │ Server: nginx
 │ Date: Thu, 01 Jan 1970 00:00:00 GMT
 │ Content-Type: application/json
 ├─ Body
 │ {
 │   "args" : {
 │   },
 │   "headers" : {
 │     "User-Agent" : "ResponseDetective\/1 CFNetwork\/758.3.15 Darwin\/15.4.0",
 │     "Accept-Encoding" : "gzip, deflate",
 │     "Host" : "httpbin.org",
 │     "Accept-Language" : "en-us",
 │     "Accept" : "*\/*"
 │   },
 │   "url" : "https:\/\/httpbin.org\/get"
 │ }
```

## Installation

### Carthage

If you're using [Carthage](https://github.com/Carthage/Carthage), add the following dependency to your `Cartfile`:

```none
github "netguru/ResponseDetective" ~> {version}
```

### CocoaPods

If you're using [CocoaPods](http://cocoapods.org), add the following dependency to your `Podfile`:

```none
use_frameworks!
pod 'ResponseDetective', '~> {version}'
```

### Swift Package Manager

If you're using [Swift Package Manager](https://github.com/apple/swift-package-manager), add this repository to the Swift Packages in your project settings.

### Local

To install the test dependencies or to build ResponseDetective itself, do not run `carthage` directly. It can't handle the Apple Silicon architectures introduced in Xcode 12. Instead, run it through the `carthage.sh` script:

```bash
$ ./carthage.sh bootstrap
```

Alternatively, you can run the tests locally using Swift Package Manager with the following command:

```bash
$ swift test
```

## About

This project was made with ♡ by [Netguru](https://netguru.com).

### Release names

Starting from version 1.0.0, ResponseDetective's releases are named after [Sherlock Holmes canon stories](http://www.sherlockian.net/investigating/canon/), in chronological order. **What happens if we reach 60 releases and there are no more stories?** We don't know, maybe we'll start naming them after cats or something.

### License

This project is licensed under **MIT License**. See [LICENSE.md](LICENSE.md) for more info.
