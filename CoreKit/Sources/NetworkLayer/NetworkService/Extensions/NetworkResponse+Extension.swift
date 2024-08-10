import Foundation

extension NetworkResponse {

    public static func mockFromFile(dataPath: String?, status: Int) throws -> NetworkResponse {
        guard let dataURL = dataPath.map(URL.init(fileURLWithPath:)) else { throw NSError(domain: "", code: 0) }

        return .success(
            (
                try Data(contentsOf: dataURL),
                HTTPURLResponse(
                    url: URL(string: "https://www.quivon.com.br")!,
                    statusCode: status,
                    httpVersion: nil,
                    headerFields: nil
                )!
            )
        )
    }

    public static func mock(data: Data = Data(), status: Int) -> NetworkResponse {
        .success(
            (
                data,
                HTTPURLResponse(
                    url: URL(string: "https://www.quivon.com.br")!,
                    statusCode: status,
                    httpVersion: nil,
                    headerFields: nil
                )!
            )
        )
    }
}
