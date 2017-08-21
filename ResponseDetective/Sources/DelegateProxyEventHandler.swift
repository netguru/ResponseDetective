//
// DelegateEventHandler.swift
//
// Copyright © 2017 Netguru. All rights reserved.
// Licensed under the MIT License.
//

import Foundation

/// An event that one of `URLSessionDelegate` protocols has sent.
internal enum DelegateProxyEvent {

    /// When a `URLSession` becomes invalid.
    case sessionDidBecomeInvalid(error: Error?)

    /// When a `URLSessionTask` becomes delayed due to connectivity issues.
    case taskDidBecomeDelayed(task: URLSessionTask)

    /// When a previously delayed `URLSessionTask` is resumed.
    case taskDidResumeDelayed(task: URLSessionTask)

    /// When a `URLSessionTask` completes.
    case taskDidComplete(task: URLSessionTask, error: Error?)

    /// When a `URLSessionDataTask` receives a `URLResponse`.
    case taskDidReceiveResponse(task: URLSessionDataTask, response: URLResponse)

    /// When a `URLSessionDataTask` receives `Data`.
    case taskDidReceiveData(task: URLSessionDataTask, data: Data)

    /// When a `URLSessionDownloadTask` finishes downloading.
    case taskDidFinishDownloading(task: URLSessionDownloadTask, url: URL)

}

// MARK: -

/// An object that handles cases of `DelegateProxyEvent` sent by
/// `DelegateProxy`. This is essentially a bridge between `DelegateProxy` and
/// a network traffic recorder that accumulates information about sent requests,
/// received responses and thrown errors.
///
/// Only one instance of `DelegateProxyEventHandler` should be used for one
/// instance of `DelegateProxy`.
internal final class DelegateProxyEventHandler {

    // MARK: Initializers



    // MARK: Handling

    /// Handle a delegate event.
    ///
    /// - Parameters:
    ///     - event: An event to handle.
    internal func handle(event: DelegateProxyEvent) {

    }

}
