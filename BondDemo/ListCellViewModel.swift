//
//  RepositoryCellViewModel.swift
//  BondDemo
//
//  Created by Srđan Rašić on 26/01/15.
//  Copyright (c) 2015 Srdan Rasic. All rights reserved.
//

import UIKit
import Bond

class ListCellViewModel {
  let name: Observable<String>
  let username: Observable<String>
  let photo: Observable<UIImage?>
  let photoUrl: String?
  
  init(name: String, username: String, photoUrl: String?) {
    self.name = Observable(name)
    self.username = Observable(username)
    self.photo = Observable<UIImage?>(nil) // initially no photo
    self.photoUrl = photoUrl
  }
  
  func fetchPhotoIfNeeded() {
    if self.photo.value != nil {
      // already have photo
      return
    }
    
    if let photoUrl = photoUrl {
      if let photoUrl = NSURL(string: photoUrl) {
        let downloadTask = NSURLSession.sharedSession().downloadTaskWithURL(photoUrl) {
          [weak self] location, response, error in
          if let location = location {
            if let data = NSData(contentsOfURL: location) {
              if let image = UIImage(data: data) {
                dispatch_async(dispatch_get_main_queue()) {
                  // this will automatically update photo in bonded image view
                  self?.photo.value = image
                  return
                }
              }
            }
          }
        }
        downloadTask.resume()
      }
    }
  }
}
