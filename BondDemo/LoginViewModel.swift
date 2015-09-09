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
  let username = Observable<String?>("Steve")
  let password = Observable<String?>("")

  let loginState = Observable<LoginState>(.None)

  // true while login is in progress, and false otherwise
  private var loginInProgress: EventProducer<Bool> {
    return loginState.map { $0 == LoginState.InProgress }
  }

  var activityIndicatorVisible: EventProducer<Bool> {
    return loginInProgress
  }

  var loginButtonEnabled: EventProducer<Bool> {
    let usernameValid = username.map { $0!.characters.count > 2 }
    let passwordValid = password.map { $0!.characters.count > 2 }
    return usernameValid.combineLatestWith(passwordValid).combineLatestWith(loginInProgress).map { inputs, progress in
      inputs.0 == true && inputs.1 == true && progress == false
    }
  }

  func login() {
    self.loginState.value = .InProgress
    print("Logging in as \(username.value).")

    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, dispatch_get_main_queue()) {
      print("Logged in as \(self.username.value).")
      self.loginState.value = .LoggedIn
    }
  }
}
