/*
Copyright (c) 2016 Dominik Hauser <dom@dasdom.de>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

Created by dasdom on 05.01.16.
Updated to Swift 3 by Audrey Tam on 28.11.16
*/

import Foundation

public protocol DHURLSession {   // 协议中定义的方法-->动态派发
  func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
  func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: DHURLSession { } // 协议扩展中的方法-->静态派发

public final class URLSessionMock : DHURLSession {
  
  var url: URL?
  var request: URLRequest?
  private let dataTaskMock: URLSessionDataTaskMock
  
  public convenience init?(jsonDict: [String: Any], response: URLResponse? = nil, error: Error? = nil) {
    guard let data = try? JSONSerialization.data(withJSONObject: jsonDict, options: []) else { return nil }
    self.init(data: data, response: response, error: error)
  }
  
  public init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
    dataTaskMock = URLSessionDataTaskMock()
    dataTaskMock.taskResponse = (data, response, error)
  }
  
    // MARK: - 实现DHURLSession协议中的方法
  public func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
      self.url = url
      self.dataTaskMock.completionHandler = completionHandler
      return self.dataTaskMock
  }
  
  public func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
      self.request = request
      self.dataTaskMock.completionHandler = completionHandler
      return self.dataTaskMock
  }
  
    // MARK: - 私有内部类: URLSessionDataTaskMock
  final private class URLSessionDataTaskMock : URLSessionDataTask {
    
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    var completionHandler: CompletionHandler?
    var taskResponse: (Data?, URLResponse?, Error?)?
    
    override func resume() {
      DispatchQueue.main.async {
        self.completionHandler?(self.taskResponse?.0, self.taskResponse?.1, self.taskResponse?.2)
      }
    }
  }
}
