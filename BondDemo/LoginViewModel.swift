//
//  LoginViewModel.swift
//  BondDemo
//
//  Created by Srđan Rašić on 01/03/15.
//  Copyright (c) 2015 Srdan Rasic. All rights reserved.
//

import Bond

enum LoginState {
  case None
  case InProgress
  case LoggedIn
}

class LoginViewModel {
  let username = Dynamic<String>("Steve")
  let password = Dynamic<String>("")
  
  let loginState = Dynamic<LoginState>(.None)
  
  // true while login is in progress, and false otherwise
  private var loginInProgress: Dynamic<Bool> {
    return loginState.map { $0 == LoginState.InProgress }
  }
  
  var loginButtonEnabled: Dynamic<Bool> {
    let usernameValid = username.map { count($0) > 2 }
    let passwordValid = password.map { count($0) > 2 }
    return reduce(usernameValid, passwordValid, loginInProgress) { $0 && $1 && $2 == false }
  }
  
  var activityIndicatorVisible: Dynamic<Bool> {
    return loginInProgress
  }
  
  func login() {
    self.loginState.value = .InProgress
    println("Logging in as \(username.value).")

    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, dispatch_get_main_queue()) {
      println("Logged in as \(self.username.value).")
      self.loginState.value = .LoggedIn
    }
  }
}
