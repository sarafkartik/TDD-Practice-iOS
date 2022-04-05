//
//  UserFetchCommand.swift
//  TestCasesPractice
//
//  Created by Srijan on 05/04/22.
//

import Foundation

struct UserFetchCommand:Equatable{
    let userName:String
    let password:String
    
    func execute<A>(_ userProvider:(String, String) -> Result<UserData, Error>, onSuccess:(UserData) -> A, onError:(Error) -> A) -> A{
        let result = userProvider(userName,password)
        switch result {
        case .success(let user): return onSuccess(user)
        case .failure(let error): return onError(error)
        }
    }
}
