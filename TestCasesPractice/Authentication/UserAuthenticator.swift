//
//  Authenticator.swift
//  TestCasesPractice
//
//  Created by Srijan on 05/04/22.
//

import Foundation
class UserAuthenticator{
    
    
    func authenticate(username:String,password:String)-> AuthenticationResult{
        let credentialValidations =  [
            validateUsername(username),
            validatePassword(password),
        ].compactMap{$0}
        
        if (!credentialValidations.isEmpty){
            return .Error(credentialValidations)
        } else {
            return .Partial(UserFetchCommand(userName: username, password: password))
        }
        
    }
    
    private func validateUsername(_ username:String) -> ValidationError?{
        if (username.isEmpty){
            return .EmptyUsername
        }
        return nil
    }
    
    private func validatePassword(_ password:String) -> ValidationError?{
        if (password.isEmpty){
            return .EmptyPassword
        }
        return nil
    }
}
