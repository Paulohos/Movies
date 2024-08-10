import Foundation

extension NetworkService {
    enum PrintDescriptionType {
        case headerAndBody(_ urlRequest: URLRequest)
        case response(_ urlRequest: URLRequest, _ data: Data, _ response: HTTPURLResponse)
        case erroParse(_ error: Error)
    }

    func printDescription(type: PrintDescriptionType) {
        #if DEBUG
        switch type {
        case .headerAndBody(let urlRequest):
            printHeaderAndBody(urlRequest: urlRequest)

        case let .response(urlRequest, data, response):
            printResponse(urlRequest, data, response)

        case .erroParse(let error):
            print("\n\n❌---Error Parse---\n\n", error)
        }
        #endif
    }

    private func printHeaderAndBody(urlRequest: URLRequest) {
        print("\n\n=======================================================\n")
        print("🤯 HEADER: \n", urlRequest.allHTTPHeaderFields ?? "NO HEADER")

        print("\n\n\n🏋🏻BODY REQUEST:")
        debugPrint("HTTP Method = \(urlRequest.httpMethod ?? "NO HTTP METHOD")")
        debugPrint("URL =  \(urlRequest.url?.absoluteString ?? "NO URL")")
        guard let data = urlRequest.httpBody else {
            print("🕺BODY: \nNOTHING IN REQUEST BODY \n\n")
            print("================================================\n\n")
            return
        }

        guard data.count < (400000 * 1024) else {
            print("⚠️ Request BODY is too big")
            print("\n\n\n================================================\n\n")
            return
        }
        debugPrint("🕺BODY:")
        debugPrint(data.prettyPrintedJSONString ?? "NOTHING IN REQUEST BODY")
        print("\n========================================================\n\n")
    }

    private func printResponse(_ urlRequest: URLRequest, _ data: Data, _ response: HTTPURLResponse) {
        print("\n\n=======================================================\n\n")
        switch response.statusCode {
        case 200...299:
            print("✅ RESPONSE:")
        default:
            print("❌ RESPONSE:")
        }
        debugPrint("HTTP Method = \(urlRequest.httpMethod ?? "No HTTP Method")")
        debugPrint("URL =  \(urlRequest.url?.absoluteString ?? "No URL")")
        debugPrint("Status code = \(response.statusCode)")
        debugPrint(data.prettyPrintedJSONString ?? "NOTHIN IN REQUEST RESPONSE BODY")
        print("\n\n\n=======================================================\n\n\n")
    }
}
