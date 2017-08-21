//
// DelegateProxy.swift
//
// Copyright © 2017 Netguru. All rights reserved.
// Licensed under the MIT License.
//
// Inspired by ReactiveCocoa.
//

import Foundation

/// A delegate proxy object for all `URLSessionDelegate` protocols that forwards
/// delegate invocations to underlying base delegate object and handles delegate
/// events that ResponseDetective is interested in.
///
/// Only one instance of `DelegateProxy` should be used for one instance of
/// `URLSession`.
internal final class DelegateProxy: NSObject {

    // MARK: Initializers

    /// Initialize a delegate proxy.
    ///
    /// - Parameters:
    ///     - base: An underlying base delegate object.
    ///     - eventHandler: An object that handles delegate proxy events.
    internal init(base: NSObjectProtocol?, eventHandler: DelegateProxyEventHandler) {
        self.base = base
        self.eventHandler = eventHandler
    }

    // MARK: Properties

    /// The base delegate object of any type.
    internal weak var base: NSObjectProtocol?

    /// An object that handles delegate proxy events.
    private let eventHandler: DelegateProxyEventHandler

    /// The base `URLSessionDelegate` object.
    private var baseSessionDelegate: URLSessionDelegate? {
        return base as? URLSessionDelegate
    }

    /// The base `URLSessionTaskDelegate` object.
    private var baseSessionTaskDelegate: URLSessionTaskDelegate? {
        return base as? URLSessionTaskDelegate
    }

    /// The base `URLSessionDataDelegate` object.
    private var baseSessionDataDelegate: URLSessionDataDelegate? {
        return base as? URLSessionDataDelegate
    }

    /// The base `URLSessionDownloadDelegate` object.
    private var baseSessionDownloadDelegate: URLSessionDownloadDelegate? {
        return base as? URLSessionDownloadDelegate
    }

    /// The base `URLSessionStreamDelegate` object.
    private var baseSessionStreamDelegate: URLSessionStreamDelegate? {
        return base as? URLSessionStreamDelegate
    }

    // MARK: Helpers

    /// An implementation of a delegate method.
    ///
    /// - Parameters:
    ///     - method: A method of one of the base delegates.
    ///     - forwardClosure: A closure executed if method is implemented.
    ///     - fallbackClosure: A closure executed if method is not implemented.
    ///     - event: An event to notify.
    private func delegateMethodImplementation<Method>(method: Method?, forward forwardClosure: (Method) -> Void, fallback fallbackClosure: () -> Void = {}, notify event: DelegateProxyEvent? = nil) {
        if let event = event {
            eventHandler.handle(event: event)
        }
        if let method = method {
            forwardClosure(method)
        } else {
            fallbackClosure()
        }
    }

}

// MARK: -

extension DelegateProxy: URLSessionDelegate {

    // MARK: Handled

    /// - SeeAlso: URLSessionDelegate.urlSession(_:didBecomeInvalidWithError:)
    internal func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        delegateMethodImplementation(
            method: baseSessionDelegate?.urlSession(_:didBecomeInvalidWithError:),
            forward: { $0(session, error) },
            notify: .sessionDidBecomeInvalid(error: error)
        )
    }

    // MARK: Unhandled

    /// - SeeAlso: URLSessionDelegate.urlSession(_:didReceive:completionHandler:)
    internal func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        delegateMethodImplementation(
            method: baseSessionDelegate?.urlSession(_:didReceive:completionHandler:),
            forward: { $0(session, challenge, completionHandler) },
            fallback: { completionHandler(.performDefaultHandling, challenge.proposedCredential) }
        )
    }

}

// MARK: -

extension DelegateProxy: URLSessionTaskDelegate {

    // MARK: Handled

    /// - SeeAlso: URLSessionTaskDelegate.urlSession(_:taskIsWaitingForConnectivity:)
    @available(iOS 11.0, macOS 10.13, tvOS 11.0, *) internal func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        delegateMethodImplementation(
            method: baseSessionTaskDelegate?.urlSession(_:taskIsWaitingForConnectivity:),
            forward: { $0(session, task) },
            notify: .taskDidBecomeDelayed(task: task)
        )
    }

    /// - SeeAlso: URLSessionTaskDelegate.urlSession(_:task:willBeginDelayedRequest:completionHandler:)
    @available(iOS 11.0, macOS 10.13, tvOS 11.0, *) internal func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest request: URLRequest, completionHandler: @escaping (URLSession.DelayedRequestDisposition, URLRequest?) -> Void) {
        delegateMethodImplementation(
            method: baseSessionTaskDelegate?.urlSession(_:task:willBeginDelayedRequest:completionHandler:),
            forward: { $0(session, task, request, completionHandler) },
            fallback: { completionHandler(.continueLoading, request) },
            notify: .taskDidResumeDelayed(task: task)
        )
    }

    /// - SeeAlso: URLSessionTaskDelegate.urlSession(_:task:didCompleteWithError:)
    internal func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        delegateMethodImplementation(
            method: baseSessionTaskDelegate?.urlSession(_:task:didCompleteWithError:),
            forward: { $0(session, task, error) },
            notify: .taskDidComplete(task: task, error: error)
        )
    }

    // MARK: Unhandled

    /// - SeeAlso: URLSessionTaskDelegate.urlSession(_:task:willPerformHTTPRedirection:newRequest:completionHandler:)
    internal func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        delegateMethodImplementation(
            method: baseSessionTaskDelegate?.urlSession(_:task:willPerformHTTPRedirection:newRequest:completionHandler:),
            forward: { $0(session, task, response, request, completionHandler) },
            fallback: { completionHandler(request) }
        )
    }

    /// - SeeAlso: URLSessionTaskDelegate.urlSession(_:task:didReceive:completionHandler:)
    internal func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        delegateMethodImplementation(
            method: baseSessionTaskDelegate?.urlSession(_:task:didReceive:completionHandler:),
            forward: { $0(session, task, challenge, completionHandler) },
            fallback: { completionHandler(.performDefaultHandling, challenge.proposedCredential) }
        )
    }

    /// - SeeAlso: URLSessionTaskDelegate.urlSession(_:task:needNewBodyStream:)
    internal func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Void) {
        delegateMethodImplementation(
            method: baseSessionTaskDelegate?.urlSession(_:task:needNewBodyStream:),
            forward: { $0(session, task, completionHandler) },
            fallback: { completionHandler(task.currentRequest?.httpBodyStream) }
        )
    }

    /// - SeeAlso: URLSessionTaskDelegate.urlSession(_:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:)
    internal func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        delegateMethodImplementation(
            method: baseSessionTaskDelegate?.urlSession(_:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:),
            forward: { $0(session, task, bytesSent, totalBytesSent, totalBytesExpectedToSend) }
        )
    }

    /// - SeeAlso: URLSessionTaskDelegate.urlSession(_:task:didFinishCollecting:)
    @available(iOS 10.0, macOS 10.12, tvOS 10.0, *) internal func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        delegateMethodImplementation(
            method: baseSessionTaskDelegate?.urlSession(_:task:didFinishCollecting:),
            forward: { $0(session, task, metrics) }
        )
    }

}

// MARK: -

extension DelegateProxy: URLSessionDataDelegate {

    // MARK: Handled

    /// - SeeAlso: URLSessionDataDelegate.urlSession(_:dataTask:didReceive:completionHandler:)
    internal func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        delegateMethodImplementation(
            method: baseSessionDataDelegate?.urlSession(_:dataTask:didReceive:completionHandler:),
            forward: { $0(session, dataTask, response, completionHandler) },
            fallback: { completionHandler(.allow) },
            notify: .taskDidReceiveResponse(task: dataTask, response: response)
        )
    }

    /// - SeeAlso: URLSessionDataDelegate.urlSession(_:dataTask:didReceive:)
    internal func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        delegateMethodImplementation(
            method: baseSessionDataDelegate?.urlSession(_:dataTask:didReceive:),
            forward: { $0(session, dataTask, data) },
            notify: .taskDidReceiveData(task: dataTask, data: data)
        )
    }

    // MARK: Unhandled

    /// - SeeAlso: URLSessionDataDelegate.urlSession(_:dataTask:didBecome:)
    internal func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        delegateMethodImplementation(
            method: baseSessionDataDelegate?.urlSession(_:dataTask:didBecome:),
            forward: { $0(session, dataTask, downloadTask) }
        )
    }

    /// - SeeAlso: URLSessionDataDelegate.urlSession(_:dataTask:didBecome:)
    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *) internal func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {
        delegateMethodImplementation(
            method: baseSessionDataDelegate?.urlSession(_:dataTask:didBecome:),
            forward: { $0(session, dataTask, streamTask) }
        )
    }

    /// - SeeAlso: URLSessionDataDelegate.urlSession(_:dataTask:willCacheResponse:completionHandler:)
    internal func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        delegateMethodImplementation(
            method: baseSessionDataDelegate?.urlSession(_:dataTask:willCacheResponse:completionHandler:),
            forward: { $0(session, dataTask, proposedResponse, completionHandler) },
            fallback: { completionHandler(proposedResponse) }
        )
    }

}

// MARK: -

extension DelegateProxy: URLSessionDownloadDelegate {

    // MARK: Handled

    /// - SeeAlso: URLSessionDownloadDelegate.urlSession(_:downloadTask:didFinishDownloadingTo:)
    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        delegateMethodImplementation(
            method: baseSessionDownloadDelegate?.urlSession(_:downloadTask:didFinishDownloadingTo:),
            forward: { $0(session, downloadTask, location) },
            notify: .taskDidFinishDownloading(task: downloadTask, url: location)
        )
    }

    // MARK: Unhandled

    /// - SeeAlso: URLSessionDownloadDelegate.urlSession(_:downloadTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:)
    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        delegateMethodImplementation(
            method: baseSessionDownloadDelegate?.urlSession(_:downloadTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:),
            forward: { $0(session, downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) }
        )
    }

    /// - SeeAlso: URLSessionDownloadDelegate.urlSession(_:downloadTask:didResumeAtOffset:expectedTotalBytes:)
    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        delegateMethodImplementation(
            method: baseSessionDownloadDelegate?.urlSession(_:downloadTask:didResumeAtOffset:expectedTotalBytes:),
            forward: { $0(session, downloadTask, fileOffset, expectedTotalBytes) }
        )
    }

}

// MARK: -

extension DelegateProxy: URLSessionStreamDelegate {

    // MARK: Unhandled

    /// - SeeAlso: URLSessionStreamDelegate.urlSession(_:readClosedFor:)
    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *) internal func urlSession(_ session: URLSession, readClosedFor streamTask: URLSessionStreamTask) {
        delegateMethodImplementation(
            method: baseSessionStreamDelegate?.urlSession(_:readClosedFor:),
            forward: { $0(session, streamTask) }
        )
    }

    /// - SeeAlso: URLSessionStreamDelegate.urlSession(_:writeClosedFor:)
    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *) internal func urlSession(_ session: URLSession, writeClosedFor streamTask: URLSessionStreamTask) {
        delegateMethodImplementation(
            method: baseSessionStreamDelegate?.urlSession(_:writeClosedFor:),
            forward: { $0(session, streamTask) }
        )
    }

    /// - SeeAlso: URLSessionStreamDelegate.urlSession(_:betterRouteDiscoveredFor:)
    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *) internal func urlSession(_ session: URLSession, betterRouteDiscoveredFor streamTask: URLSessionStreamTask) {
        delegateMethodImplementation(
            method: baseSessionStreamDelegate?.urlSession(_:betterRouteDiscoveredFor:),
            forward: { $0(session, streamTask) }
        )
    }

    /// - SeeAlso: URLSessionStreamDelegate.urlSession(_:streamTask:didBecome:outputStream:)
    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *) internal func urlSession(_ session: URLSession, streamTask: URLSessionStreamTask, didBecome inputStream: InputStream, outputStream: OutputStream) {
        delegateMethodImplementation(
            method: baseSessionStreamDelegate?.urlSession(_:streamTask:didBecome:outputStream:),
            forward: { $0(session, streamTask, inputStream, outputStream) }
        )
    }

}
