 import Foundation
 import UnserAPIKit
 import Quick
 import Nimble

 public func makeHttpURLResponse(statusCode: Int = 200) -> HTTPURLResponse {
   return HTTPURLResponse(
     url: URL(string: "https//www.google.com")!, statusCode: statusCode, httpVersion: nil,
     headerFields: nil)!
 }

 public func makeError() -> Error { return NSError(domain: "1", code: 1, userInfo: nil) }

 public class HttpClientTestDouble: HttpClient {
   private var completion: ((HttpClient.Result) -> Void)? = nil
   public var endpoint: Endpoint? = nil
   public var networkRequest: NetworkRequest? = nil
   public init() {}
   public func request(
     endpoint: Endpoint, networkRequest: NetworkRequest,
     completion: @escaping (HttpClient.Result) -> Void
   ) {
     self.endpoint = endpoint
     self.completion = completion
     self.networkRequest = networkRequest
   }
   public func completeRequest(_ result: HttpClient.Result) { self.completion?(result) }
   public func expectEndpoint(
     path: String, httpMethod: HttpMethod?, queryParameters: QueryParameters?, headers: Headers?,
     contentType: ContentType, acceptType: AcceptType, resolveAgainstBaseURL: Bool, data: Data?,
     body: [String: Encodable]? = nil
   ) {
    guard let endpoint = endpoint else {
      fail("Endpoint not set, no request has been sent")
      return
    }
     expect(endpoint.path) == path
     if let httpMethod = httpMethod { expect(endpoint.httpMethod) == httpMethod } else {
       expect(endpoint.httpMethod).to(beNil())
     }
     if let queryParameters = queryParameters {
       expect(endpoint.queryParameters) == queryParameters
     } else {
       expect(endpoint.queryParameters).to(beNil())

     }
     if let headers = headers { expect(endpoint.headers) == headers } else {
       expect(endpoint.headers).to(beNil())

     }
     expect(endpoint.contentType) == contentType
     expect(endpoint.acceptType) == acceptType
     if let data = data { expect(endpoint.data) == data } else {
       expect(endpoint.data).to(beNil())
     }
   }
 }
