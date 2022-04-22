//
//  CoreImageCollectionViewController.swift
//  Monitor
//
//  Created by Fri on 2022/4/14.
//

import UIKit

final class CoreImageContentViewController: UITableViewController {
  private weak var flow: CoreImageContentFlow?
  private let items = CoreImageContentBranch.allContents
  init(flow: CoreImageContentFlow) {
    self.flow = flow
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "CoreImage"
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    items.count
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    flow?.direct(to: items[indexPath.row])
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let c = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
    c.textLabel?.text = "\(items[indexPath.row])"
    return c
  }
}
