import Foundation

// MARK: - Mockable

protocol Mockable {
  static func decode<T: Decodable>(fromFile filename: String, ofType ext: String, dateFormatter: JSONDecoder.DateDecodingStrategy, bundle: Bundle) -> T
}

// MARK: - Mocker

struct Mocker: Mockable {}

extension Mockable {

  static func decode<T: Decodable>(fromFile filename: String, ofType ext: String = "json", dateFormatter: JSONDecoder.DateDecodingStrategy = .iso8601, bundle: Bundle = Bundle.main) -> T {
    guard let data = getData(fromFile: filename, ofType: ext, bundle: bundle) else { fatalError("Can't generate Data from the mocked file. File: \(filename).\(ext)")
    }
    return decode(fromData: data, dateFormatter: dateFormatter)
  }

  static func decode<T: Decodable>(fromData data: Data, ofType ext: String = "json", dateFormatter: JSONDecoder.DateDecodingStrategy = .iso8601, bundle: Bundle = Bundle.main) -> T {
    do {
      let object: T = try JSONDecoder.decode(data, dateFormat: dateFormatter)
      return object
    } catch { fatalError("Can't decode object: \(error)") }
  }

  static func getData(fromFile filename: String, ofType ext: String = "json", bundle: Bundle = Bundle.main) -> Data? {
    guard
      let path = bundle.path(forResource: filename, ofType: ext)
    else { fatalError("Can't find the bundle path. File: \(filename).\(ext)") }

    let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    return data
  }

}
