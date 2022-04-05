//
//  TestCasesPracticeTests.swift
//  TestCasesPracticeTests
//
//  Created by Srijan on 04/04/22.
//

import XCTest
@testable import TestCasesPractice

func userDataProviderForTest() -> UserData{
    return UserData(userName: "")
}

func anotherUserDataProviderForTest() -> UserData{
    return UserData(userName: "new")
}

class TestCasesPracticeTests: XCTestCase {
    
    struct MockError:Error,Equatable{
        let message:String
    }
    
    let valid_username = "abcd"
    let valid_password = "password@1"
    
  
    func testItShouldAutheticateBasedOnUsernameAndPassword(){
        let authenticator = UserAuthenticator()
        authenticator.authenticate(username:valid_username,password:valid_password)
    }
    
    func testItShouldReturnAnErrorWhenUsernameIsEmpty(){
        let authenticator = UserAuthenticator()
        let result = authenticator.authenticate(username: "", password: valid_password)
        XCTAssert(result == .Error([ValidationError.EmptyUsername]))
    }
    
    func testItShouldReturnAnErrorWhenPasswordIsEmpty(){
        let authenticator = UserAuthenticator()
        let result = authenticator.authenticate(username: valid_username, password: "")
        XCTAssert(result == .Error([ValidationError.EmptyPassword]))
    }
    
    func testItShouldReturnAnErrorWhenUsernameAndPasswordIsEmpty(){
        let authenticator = UserAuthenticator()
        let result = authenticator.authenticate(username: "", password: "")
        XCTAssert(result == .Error([ValidationError.EmptyUsername,ValidationError.EmptyPassword]))
    }
    
    func testItShouldReturnPartialCommandIfValidationsAreSuccessful(){
        let authenticator = UserAuthenticator()
        let result = authenticator.authenticate(username: valid_username, password: valid_password)
        XCTAssert(result == .Partial(UserFetchCommand(userName: valid_username,password: valid_password)))
    }
    
    func testItShouldReturnCommandForGivenUserNameAndPassword(){
        let authenticator = UserAuthenticator()
        let result = authenticator.authenticate(username: "abcd", password: "password")
        XCTAssert(result == .Partial(UserFetchCommand(userName: "abcd",password: "password")))
    }
    
    func testUSerFetchCommandExecutesItselfAndProvidesErrorIfUSerNotFound(){
        let command = UserFetchCommand(userName: "abcd", password: "password")
        
        let expectedError = MockError(message: "error")
        
        let userProvider:(String, String) -> Result<UserData, Error> = {_,_ in Result.failure(expectedError) }
        
        let didWeReceivedError = command.execute(userProvider, onSuccess:{ _ in false }, onError: { $0 as! MockError == expectedError})
        
        XCTAssert(didWeReceivedError)

    }
    
    func testUserFetchCommandExecutesItselfProvidesTheErrorFromResult(){
        let command = UserFetchCommand(userName: "abcd", password: "password")
        
        let expectedError = MockError(message: "anotherError")
        
        let userProvider:(String, String) -> Result<UserData, Error> = {_,_ in Result.failure(expectedError) }
        
        let didWeReceivedError = command.execute(userProvider, onSuccess:{ _ in false }, onError: { $0 as! MockError == expectedError})
        
        XCTAssert(didWeReceivedError)

    }
    
    func testUserFetchCommandExecutesItselfAndProvidesTheUserDataOnSuccess(){
        let command = UserFetchCommand(userName: "abcd", password: "password")
    
        let expectedUser = userDataProviderForTest()
        
        let userProvider:(String, String) -> Result<UserData, Error> = {_,_ in .success(expectedUser) }
        
        let didWeReceivedUser = command.execute(userProvider, onSuccess:{ $0 == expectedUser }, onError: { _ in false })
        
        XCTAssert(didWeReceivedUser)

    }
    
    func testUserFetchCommandExecutesWithGivenUserNameAndPassword(){
        let command = UserFetchCommand(userName: "abcd", password: "password")
    
        let expectedUser = anotherUserDataProviderForTest()
        
        let userProvider:(String, String) -> Result<UserData, Error> = {userName, password in
            if (userName == "abcd" && password == "password"){
                return .success(anotherUserDataProviderForTest())
            }
            return .failure(MockError(message:"Should Not Happen"))
        }
        
        let didWeReceivedUser = command.execute(userProvider, onSuccess:{ $0 == expectedUser }, onError: { _ in false })
        
        XCTAssert(didWeReceivedUser)

    }
    
}
