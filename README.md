![](Images/Header.png)

![](https://www.bitrise.io/app/c09426001dedd91c.svg?token=4zhZMFtDpH-9BhWvGP5-1g&branch=develop)
![](https://img.shields.io/badge/swift-2.2-orange.svg)
![](https://img.shields.io/github/release/netguru/ResponseDetective.svg)
![](https://img.shields.io/badge/carthage-compatible-green.svg)
![](https://img.shields.io/badge/cocoapods-compatible-green.svg)

**ResponseDetective** is a non-intrusive framework for intercepting any outgoing requests and incoming responses between your app and your server for debugging purposes.

## Requirements

ResponseDetective is written in **Swift 2.2** and requires **iOS 9** or **OS X 10.11**.

## Usage

Incorporating ResponseDetective in your project is very simple – it all comes down to just two steps:

### Step 1: Enable interception

For ResponseDetective to work, it needs to be added as a middleman between your `NSURLSession` and the Internet. You can do this by registering the provided `URLProtocolClass` in your session's `NSURLSessionConfiguration.protocolClasses`, or use a shortcut method:

```swift
let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
ResponseDetective.enableInURLSessionConfiguration(configuration)
```

Then, you should use that configuration with your `NSURLSession`:

```swift
let session = NSURLSession(configuration: configuration)
```

Or, if you're using [Alamofire](https://github.com/Alamofire/Alamofire) as your networking framework, integrating ResponseDetective comes down to just initializing your `Manager` with the above `NSURLSessionConfiguration`:

```swift
let manager = Alamofire.Manager(configuration: configuration)
```

And that's all!

### Step 2: Profit

Now it's time to perform the actual request:

```swift
let request = NSURLRequest(URL: NSURL(string: "http://httpbin.org/get")!)
session.dataTaskWithRequest(request).resume()
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

If you're using [Carthage](https://github.com/Carthage/Carthage), just add the following dependency to your `Cartfile`:

```none
github "netguru/ResponseDetective"
```

### CocoaPods

Using ResponseDetective with [CocoaPods](http://cocoapods.org) is as easy as adding the following dependency to your `Podfile`:

```none
use_frameworks!
pod 'ResponseDetective'
```

## About

This project is made with <3 by [Netguru](https://netguru.co/opensource) and maintained by:

- Adrian Kashivskyy ([github](https://github.com/akashivskyy), [twitter](https://twitter.com/akashivskyy))
- Aleksander Popko ([github](https://github.com/APbjj))

### License

ResponseDetective is licensed under the MIT License. See [LICENSE.md](LICENSE.md) for more info.
