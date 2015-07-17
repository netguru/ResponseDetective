# ResponseDetective

![](https://img.shields.io/circleci/project/netguru/ResponseDetective.svg)
![](https://img.shields.io/badge/swift-1.2-orange.svg)
![](https://img.shields.io/github/release/netguru/ResponseDetective.svg)
![](https://img.shields.io/badge/carthage-compatible-brightgreen.svg)

**ResponseDetective** is a non-intrusive framework for intercepting any outgoing requests and incoming responses between your app and your server for debugging purposes.

## Usage

Incorporating ResponseDetective in your project is very simple – it all comes down a couple of steps.

### Step 1: Register interceptors

You may register as many request, response and error interceptors as you like.

```swift
// request
InterceptingProtocol.registerRequestInterceptor(BaseInterceptor())
InterceptingProtocol.registerRequestInterceptor(JSONInterceptor())

// response
InterceptingProtocol.registerResponseInterceptor(BaseInterceptor())
InterceptingProtocol.registerResponseInterceptor(JSONInterceptor())
InterceptingProtocol.registerResponseInterceptor(HTMLInterceptor())

// error
InterceptingProtocol.registerErrorInterceptor(BaseInterceptor())
```

### Step 2: Register the protocol

For `InterceptingProtocol` to work, it needs to be added as a middleman between your `NSURLSession` and the Internet. You can do this by registering it in your session's `NSURLSessionConfiguration.protocolClasses`.

```swift
let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
configuration.protocolClasses = [InterceptingProtocol.self]

let session = NSURLSession(configuration: configuration)
```

### Step 3: Profit

Now it's time to perform the actual request.

```swift
let request = NSURLRequest(URL: NSURL(string: "http://httpbin.org/get")!)
let task = session.dataTaskWithRequest(request)
task.resume()
```

Voilà! Now check out your console output.

```none
200 no error

Content-Length: 301
Server: nginx
Content-Type: application/json
Access-Control-Allow-Origin: *
Date: Wed, 08 Jul 2015 13:10:13 GMT
Access-Control-Allow-Credentials: true
Connection: keep-alive

{
  "args" : {

  },
  "headers" : {
    "User-Agent" : "ResponseDetective\/1 CFNetwork\/711.4.6 Darwin\/15.0.0",
    "Accept-Encoding" : "gzip, deflate",
    "Host" : "httpbin.org",
    "Accept-Language" : "en-us",
    "Accept" : "*\/*"
  },
  "origin" : "109.206.223.85",
  "url" : "http:\/\/httpbin.org\/get"
}
```

## Builtin interceptors

There are following builtin interceptors:

| Interceptor          | Description                                                                          |
|----------------------|--------------------------------------------------------------------------------------|
| HeadersInterceptor   | intercepts all requests and responses and displays their metadata, including errors. |
| HTMLInterceptor      | intercepts only HTML requests and responses.                                         |
| ImageInterceptor -   | intercepts only image responses.                                                     |
| JSONInterceptor -    | intercepts only JSON requests and responses.                                         |
| PlainTextInterceptor | intercepts only text/plain requests and responses.                                   |
| XMLInterceptor       | intercepts only XML requests and responses.                                          |

## Installation

### Carthage

If you're using [Carthage](https://github.com/Carthage/Carthage), just add the following dependency to your `Cartfile`:

```none
github "netguru/ResponseDetective"
```

## About

### Maintainers

**Adrian Kashivskyy**

- [https://github.com/akashivskyy](https://github.com/akashivskyy)
- [https://twitter.com/akashivskyy](https://twitter.com/akashivskyy)

**Aleksander Popko**

- [https://github.com/APbjj](https://github.com/APbjj)

### License

ResponseDetective is licensed under the MIT License. See [LICENSE.md](LICENSE.md).
