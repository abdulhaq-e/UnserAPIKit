import Foundation
import Nimble
import Quick

public typealias asyncCompletion<T> = ((Result<T, Error>) -> Void)

public func runAsyncExpectingSuccess<T>(
  _ asyncCallback: (@escaping asyncCompletion<T>) -> Void, when action: () -> Void,
  file: StaticString = #file, line: UInt = #line
) -> T? {
  guard let response = runAndWaitForAsyncCall(asyncCallback, when: action, file: file, line: line)
  else {
    fail("should have received any response", file: file, line: line)
    return nil
  }

  switch response {
  case .success(let receivedResult):
    return receivedResult
  default:
    fail("should not fail", file: file, line: line)
    return nil
  }
}

public func runAsyncExpectingFailure<T>(
  _ asyncCallback: (@escaping asyncCompletion<T>) -> Void, when action: () -> Void,
  file: StaticString = #file, line: UInt = #line
) -> Error? {
  guard let response = runAndWaitForAsyncCall(asyncCallback, when: action, file: file, line: line)
  else {
    fail("should have received any response", file: file, line: line)
    return nil
  }

  switch response {
  case .failure(let receivedError):
    return receivedError
  default:
    fail("should not succeed", file: file, line: line)
    return nil
  }
}

public func runAndWaitForAsyncCall<T>(
  _ asyncCallback: (@escaping asyncCompletion<T>) -> Void, when action: () -> Void,
  file: StaticString = #file, line: UInt = #line
) -> Result<T, Error>? {

  let exp = QuickSpec.current.expectation(description: "wait")
  var receivedResult: Result<T, Error>? = nil
  asyncCallback {
    receivedResult = $0
    exp.fulfill()
  }

  action()
  QuickSpec.current.wait(for: [exp], timeout: 1)

  return receivedResult

}

