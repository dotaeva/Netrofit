import Foundation

public protocol NetrofitResponse {
    var request: URLRequest { get set }
    var body: Data? { get set }
    var headers: [String: String]? { get set }
    var statusCode: Int? { get set }
    var error: Error? { get set }
    func validate() throws
}
