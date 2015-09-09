//
//  ListViewModel.swift
//  BondDemo
//
//  Created by Srđan Rašić on 26/01/15.
//  Copyright (c) 2015 Srdan Rasic. All rights reserved.
//

import Foundation
import Bond

class ListViewModel {
  let repositoryCellViewModels: ObservableArray<ListCellViewModel>

  private let apiURL: String
  private var since = 0

  init(githubApi: String) {
    repositoryCellViewModels = ObservableArray([])
    apiURL = githubApi
  }

  func fetchNextPageOfRepositories(completion: () -> Void) {
    // do it in background queue
    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
    dispatch_async(dispatch_get_global_queue(priority, 0)) {

      // fetch JSON of repositories, starting from last repo we have
      if let data = NSData(contentsOfURL: NSURL(string: self.apiURL + "?since=\(self.since)")!) {
        if let jsonResult = (try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))) as? NSArray {
          dispatch_async(dispatch_get_main_queue()) {
            // parse JSON
            var newRepos: [ListCellViewModel] = []

            for repo in jsonResult {
              if let repo = repo as? NSDictionary {
                let id = (repo["id"] as? Int) ?? 0
                let name = (repo["name"] as? String) ?? ""

                var username: String = ""
                var photoURL: String? = nil

                if let owner = repo["owner"] as? NSDictionary {
                  username = (owner["login"] as? String) ?? ""
                  photoURL = owner["avatar_url"] as? String
                }

                self.since = max(self.since, id)

                let cellViewModel = ListCellViewModel(name: name, username: username, photoUrl: photoURL)
                newRepos.append(cellViewModel)
              }
            }

            // update view model by adding new repos to the begining of the array
            // this will automatically trigger table view updates with new repos
            self.repositoryCellViewModels.insertContentsOf(newRepos.reverse(), atIndex: 0)

            completion()
          }
        }
      }
    }
  }
}