//
//  LoginViewController.swift
//  BondDemo
//
//  Created by Srđan Rašić on 01/03/15.
//  Copyright (c) 2015 Srdan Rasic. All rights reserved.
//

import UIKit
import Bond

class LoginViewController: UIViewController
{
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  
  let viewModel = LoginViewModel()
  
  lazy var loginButtonTapObserver: Bond<UIControlEvents> = Bond<UIControlEvents> { [unowned self] event in
    self.viewModel.login()
  }
  
  lazy var loginStateChangedObserver: Bond<LoginState> = Bond<LoginState> { [unowned self] state in
    switch state {
    case .LoggedIn(let username):
      self.performSegueWithIdentifier("showRepositories", sender: self)
      break
    default:
      break
    }
  }
  
  override func viewDidLoad() {
    // Make bi-directional binding between text fields and corresponding properties in VM
    viewModel.username <->> usernameTextField
    viewModel.password <->> passwordTextField
    
    // Show activity indicator when view model tells so
    viewModel.activityIndicatorVisible ->> activityIndicator
    
    // Enable login button when view model tells so
    viewModel.loginButtonEnabled ->> loginButton
    
    // Observe login state changes
    // Use ->| operator that does not fire at binding time when observing events
    viewModel.loginState ->| loginStateChangedObserver
    
    // Observe button taps
    // Use ->| operator that does not fire at binding time when observing events
    loginButton.dynEvent.filter(==, .TouchUpInside) ->| loginButtonTapObserver
  }
}
