//
//  ViewController.swift
//  BondDemo
//
//  Created by Srđan Rašić on 26/01/15.
//  Copyright (c) 2015 Srdan Rasic. All rights reserved.
//

import UIKit
import Bond

class ListViewController: UITableViewController {
  
  var listViewModel: ListViewModel!
  var dataSource: ObservableArray<ObservableArray<ListCellViewModel>>!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // setup refresh controll to load next set of repositories
    let refreshControl = UIRefreshControl()
    self.tableView.addSubview(refreshControl)
    refreshControl.addTarget(self, action: Selector("loadNextSet:"), forControlEvents: UIControlEvents.ValueChanged)
    
    // create view model
    listViewModel = ListViewModel(githubApi: "https://api.github.com/repositories")
    dataSource = ObservableArray([listViewModel.repositoryCellViewModels])
    
    // create a bond for table view data source

    // establish a bond between view model and table view
    dataSource.bindTo(tableView) { (indexPath, dataSource, tableView) -> UITableViewCell in
      let cell = (tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? ListCellView)!
      let viewModel = dataSource[indexPath.section][indexPath.row]
      viewModel.name.bindTo(cell.nameLabel.bnd_text).disposeIn(cell.bnd_bag)
      viewModel.username.bindTo(cell.ownerLabel.bnd_text).disposeIn(cell.bnd_bag)
      viewModel.photo.bindTo(cell.avatarImageView.bnd_image).disposeIn(cell.bnd_bag)
      viewModel.fetchPhotoIfNeeded()
      return cell
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    listViewModel.fetchNextPageOfRepositories() {}
  }
  
  func loadNextSet(refreshControl: UIRefreshControl) {
    listViewModel.fetchNextPageOfRepositories() {
      refreshControl.endRefreshing()
    }
  }
}

