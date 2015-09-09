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

  override func viewDidLoad() {
    // Make bi-directional binding between text fields and corresponding properties in VM
    viewModel.username.bidirectionalBindTo(usernameTextField.bnd_text)
    viewModel.password.bidirectionalBindTo(passwordTextField.bnd_text)

    // Show activity indicator when view model tells so
    viewModel.activityIndicatorVisible.bindTo(activityIndicator.bnd_animating)

    // Enable login button when view model tells so
    viewModel.loginButtonEnabled.bindTo(loginButton.bnd_enabled)

    // Observe login state changes
    // Use observeNew that does not fire at binding time when observing events
    viewModel.loginState.observeNew { [unowned self] state in
        switch state {
        case .LoggedIn:
            self.performSegueWithIdentifier("showRepositories", sender: self)
            break
        default:
            break
        }
    }
    
    // Observe button taps
    // Use ObserveNew operator that does not fire at binding time when observing events
    loginButton.bnd_controlEvent
        .filter { $0 == UIControlEvents.TouchUpInside }
        .observeNew { [unowned self] event in
            self.viewModel.login()
    }
  }
}
