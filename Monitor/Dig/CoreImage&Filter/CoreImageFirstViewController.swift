//
//  CoreImageFirstViewController.swift
//  Monitor
//
//  Created by Fri on 2022/4/22.
//

import UIKit

final class CoreImageFirstViewController: UITableViewController {
  
  var items = [kCICategoryBuiltIn,
               "Filter Cells"]
  let filters = CIFilter.filterNames(inCategory: kCICategoryBuiltIn)
  
  init() {
    super.init(nibName: nil, bundle: nil)
    title = "filter \(filters.count)"
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    items.count
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if indexPath.row == 0{
      navigationController?.pushViewController(FirstViewController(items: filters), animated: true)
    }
    switch indexPath.row {
    case 1:
      navigationController?.pushViewController(SecondViewController(), animated: true)
    default:
      break
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let c = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
    c.textLabel?.text = "\(items[indexPath.row])"
    return c
  }
}

fileprivate final class FirstViewController: UITableViewController {
  
  let items: [String]
  
  init(items: [String]) {
    self.items = items
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    items.count
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let c = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
    c.textLabel?.text = "\(items[indexPath.row])"
    return c
  }
}

fileprivate final class SecondViewController: UITableViewController {
  
  let items: [String] =  [
    "CIPhotoEffectMono",
    "CIPhotoEffectChrome",
    "CIPhotoEffectFade",
    "CIPhotoEffectInstant",
    "CIPhotoEffectNoir",
    "CIPhotoEffectProcess",
    "CIPhotoEffectTonal",
    "CIPhotoEffectTransfer",
    "CISRGBToneCurveToLinear",
    "CIVignetteEffect",]
  
  //1.创建基于CPU的CIContext对象
  let ctx1 = CIContext(options: nil)
  //2.创建基于GPU的CIContext对象
//  let ctx2 = CIContext(cgContext: <#T##CGContext#>, options: <#T##[CIContextOption : Any]?#>)
  //3.创建基于OpenGL优化的CIContext对象，可获得实时性能
  let ctx3 = CIContext(eaglContext: EAGLContext(api: .openGLES2)!)
  let queue = DispatchQueue(label: "filterQueue")
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(Cell.self, forCellReuseIdentifier: Cell.description())
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    items.count
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let c = tableView.dequeueReusableCell(withIdentifier: Cell.description(), for: indexPath) as! Cell
    queue.async {
      print(Thread.current)
      let ciImage = CIImage(image: UIImage(named: "WechatIMG1")!)!
      let filter = CIFilter(name: self.items[indexPath.row], parameters: [kCIInputImageKey: ciImage])//(name: items[indexPath.row], )
      filter?.setDefaults()
      let outImage = filter!.outputImage!
      let cgImage = self.ctx1.createCGImage(outImage, from: outImage.extent)
      DispatchQueue.main.async {
        c.icon.image = UIImage(cgImage: cgImage!)
      }
    }
    
    return c
  }
}

fileprivate final class Cell: UITableViewCell {
  let icon = UIImageView()
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubview(icon)
    selectionStyle = .none
    icon.snp.makeConstraints{
      $0.width.height.equalTo(250)
      $0.top.bottom.centerX.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
