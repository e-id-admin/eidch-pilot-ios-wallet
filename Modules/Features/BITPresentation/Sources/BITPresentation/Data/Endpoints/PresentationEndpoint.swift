import Alamofire
import BITNetworking
import Foundation
import Moya

// MARK: - PresentationEndpointError

fileprivate enum PresentationEndpointError: Error {
  case incorrectParameters
  case incorrectData
}

// MARK: - PresentationEndpoint

enum PresentationEndpoint {
  case requestObject(url: URL)
  case submission(url: URL, presentationBody: PresentationRequestBody)
}

// MARK: TargetType

extension PresentationEndpoint: TargetType {
  var baseURL: URL {
    switch self {
    case .requestObject(let url),
         .submission(let url, _):
      url
    }
  }

  var path: String {
    switch self {
    case .requestObject,
         .submission:
      ""
    }
  }

  var method: Moya.Method {
    switch self {
    case .requestObject: .get
    case .submission: .post
    }
  }

  var task: Moya.Task {
    switch self {
    case .requestObject:
      .requestPlain
    case .submission(_, let presentationBody):
      .requestParameters(parameters: presentationBody.asDictionnary(), encoding: URLEncoding.httpBody)
    }
  }

  var headers: [String: String]? {
    switch self {
    case .requestObject:
      NetworkHeader.standard.raw
    case .submission:
      NetworkHeader.form.raw
    }
  }
}
