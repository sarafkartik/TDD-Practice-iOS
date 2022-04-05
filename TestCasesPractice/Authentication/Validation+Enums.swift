//
//  Validation+Enums.swift
//  TestCasesPractice
//
//  Created by Srijan on 05/04/22.
//

import Foundation

enum AuthenticationResult:Equatable{
    case Error([ValidationError])
    case Partial(UserFetchCommand)
}

enum ValidationError:Equatable{
    case EmptyUsername
    case EmptyPassword
}
