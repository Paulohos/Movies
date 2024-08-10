//
//  File.swift
//  
//
//  Created by Paulo Henrique Oliveira Souza on 24/04/24.
//

import Foundation

var dummyMock: Data? {
    """
    {
      "dummy": "dummy"
    }
    """.data(using: .utf8)
}

struct Dummy: Decodable {
    var dummy: String
}

var emptyMock: Data? {
    """
    {}
    """.data(using: .utf8)
}

struct NoReply: Decodable {}

var defaultErrorMock =  """
    {
    "code": 123,
    "title": "Oops... something went wrong",
    "message": "Email or password invalid"
    }
    """.data(using: .utf8)
