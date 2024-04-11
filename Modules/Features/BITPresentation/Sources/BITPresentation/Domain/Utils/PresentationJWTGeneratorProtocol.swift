import BITCredential
import BITSdJWT
import Foundation
import Spyable

@Spyable
public protocol PresentationJWTGeneratorProtocol {
  func generate(requestObject: RequestObject, rawCredential: RawCredential, presentationMetadata: PresentationMetadata) throws -> JWT
}
