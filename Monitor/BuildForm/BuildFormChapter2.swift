//
//  BuildFormChapter2.swift
//  Monitor
//
//  Created by Fri on 2022/3/29.
//
import UIKit

enum BuildFormChapter2{

  //MARK: - FromViewController
  class HotspotDriver {
    var formViewController: FormViewController!
    var sections: [Section] = []
    let toggle = UISwitch()
    
    init() {
      buildSections()
      formViewController = FormViewController(sections: sections, title: "Personal Hotspot Settings")
    }
    
    var state = Hotspot() {
      didSet {
        print(state)
        sections[0].footerTitle = state.enabledSectionTitle
        sections[1].cells[0].detailTextLabel?.text = state.password
        
        formViewController.reloadSectionFooters()
      }
    }
    
    func buildSections() {
      let toggleCell = FormCell(style: .value1, reuseIdentifier: nil)
      toggleCell.textLabel?.text = "Personal Hotspot"
      toggleCell.contentView.addSubview(toggle)
      toggle.isOn = state.isEnabled
      toggle.translatesAutoresizingMaskIntoConstraints = false
      toggle.addTarget(self, action: #selector(toggleChanged(_:)), for: .valueChanged)
      toggleCell.contentView.addConstraints([
        toggle.centerYAnchor.constraint(equalTo: toggleCell.contentView.centerYAnchor),
        toggle.trailingAnchor.constraint(equalTo: toggleCell.contentView.layoutMarginsGuide.trailingAnchor)
      ])
      
      let passwordCell = FormCell(style: .value1, reuseIdentifier: nil)
      passwordCell.textLabel?.text = "Password"
      passwordCell.detailTextLabel?.text = state.password
      passwordCell.accessoryType = .disclosureIndicator
      passwordCell.shouldHighlight = true
      
      let passwordDriver = PasswordDriver(password: state.password) { [unowned self] in
        self.state.password = $0
      }
      
      passwordCell.didSelect = { [unowned self] in
        self.formViewController.navigationController?
          .pushViewController(passwordDriver.formViewController, animated: true)
      }
      
      sections = [
        Section(cells: [toggleCell], footerTitle: state.enabledSectionTitle),
        Section(cells: [passwordCell], footerTitle: nil),
      ]
    }
    
    @objc func toggleChanged(_ sender: Any) {
      state.isEnabled = toggle.isOn
    }
  }

  class PasswordDriver {
    let textField = UITextField()
    let onChange: (String) -> ()
    var formViewController: FormViewController!
    var sections: [Section] = []
    
    init(password: String, onChange: @escaping (String) -> ()) {
      self.onChange = onChange
      buildSections()
      self.formViewController = FormViewController(sections: sections, title: "Hotspot Password", firstResponder: textField)
      textField.text = password
    }
    
    func buildSections() {
      let cell = FormCell(style: .value1, reuseIdentifier: nil)
      cell.textLabel?.text = "Password"
      cell.contentView.addSubview(textField)
      textField.translatesAutoresizingMaskIntoConstraints = false
      cell.contentView.addConstraints([
        textField.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
        textField.trailingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.trailingAnchor),
        textField.leadingAnchor.constraint(equalTo: cell.textLabel!.trailingAnchor, constant: 20)
      ])
      textField.addTarget(self, action: #selector(editingEnded(_:)), for: .editingDidEnd)
      textField.addTarget(self, action: #selector(editingDidEnter(_:)), for: .editingDidEndOnExit)
      
      sections = [
        Section(cells: [cell], footerTitle: nil)
      ]
    }
    
    @objc func editingEnded(_ sender: Any) {
      onChange(textField.text ?? "")
    }
    
    @objc func editingDidEnter(_ sender: Any) {
      onChange(textField.text ?? "")
      formViewController.navigationController?.popViewController(animated: true)
    }
  }

  //MARK: - Froms
  class Section {
    let cells: [FormCell]
    var footerTitle: String?
    init(cells: [FormCell], footerTitle: String?) {
      self.cells = cells
      self.footerTitle = footerTitle
    }
  }

  class FormCell: UITableViewCell {// 如果 cell 中有多个 button，点击事件，是不是要加进去呢？
    var shouldHighlight = false
    var didSelect: (() -> ())?
  }

  //MARK: ViewController
  class FormViewController: UITableViewController {
    var sections: [Section] = []
    var firstResponder: UIResponder?
    
    func reloadSectionFooters() {
      UIView.setAnimationsEnabled(false)
      tableView.beginUpdates()
      for index in sections.indices {
        let footer = tableView.footerView(forSection: index)
        footer?.textLabel?.text = tableView(tableView, titleForFooterInSection: index)
        footer?.setNeedsLayout()
      }
      tableView.endUpdates()
      UIView.setAnimationsEnabled(true)
    }
    
    init(sections: [Section], title: String, firstResponder: UIResponder? = nil) {
      self.firstResponder = firstResponder
      self.sections = sections
      super.init(style: .grouped)
      navigationItem.title = title
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      firstResponder?.becomeFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override func viewDidLoad() { super.viewDidLoad() }

    override func numberOfSections(in tableView: UITableView) -> Int {
      sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      sections[section].cells.count
    }
    
    func cell(for indexPath: IndexPath) -> FormCell {
      sections[indexPath.section].cells[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      cell(for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
      cell(for: indexPath).shouldHighlight
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
      sections[section].footerTitle
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      cell(for: indexPath).didSelect?()
    }
  }

}
