//
//  BuildFormChapter3.swift
//  Monitor
//
//  Created by Fri on 2022/3/29.
//

import UIKit

enum BuildFormChapter3 {
  //MARK: - FormViewController

  final class TargetAction {
    let execute: () -> ()
    init(_ execute: @escaping () -> ()) {
      self.execute = execute
    }
    @objc func action(_ sender: Any) {
      execute()
    }
  }

  struct Observer {
    var strongReferences: [Any]
    var update: (Hotspot) -> ()
  }

  static func hotspotForm(state: Hotspot,
                   change: @escaping ((inout Hotspot) -> ()) -> (),// why??
                   pushViewController: @escaping (UIViewController) -> ())
  -> ([Section], Observer) {
    
    var strongReferences: [Any] = []
    var updates: [(Hotspot) -> ()] = []
    
    let toggleCell = FormCell(style: .value1, reuseIdentifier: nil)
    let toggle = UISwitch()
    toggleCell.textLabel?.text = "Personal Hotspot"
    toggleCell.contentView.addSubview(toggle)
    toggle.isOn = state.isEnabled
    toggle.translatesAutoresizingMaskIntoConstraints = false
    let toggleTarget = TargetAction {
      change { $0.isEnabled = toggle.isOn }
    }
    strongReferences.append(toggleTarget)
    updates.append { state in
      toggle.isOn = state.isEnabled
    }
    toggle.addTarget(toggleTarget, action: #selector(TargetAction.action(_:)), for: .valueChanged)
    toggleCell.contentView.addConstraints([
      toggle.centerYAnchor.constraint(equalTo: toggleCell.contentView.centerYAnchor),
      toggle.trailingAnchor.constraint(equalTo: toggleCell.contentView.layoutMarginsGuide.trailingAnchor)
    ])
    
    let passwordCell = FormCell(style: .value1, reuseIdentifier: nil)
    passwordCell.textLabel?.text = "Password"
    passwordCell.detailTextLabel?.text = state.password
    passwordCell.accessoryType = .disclosureIndicator
    passwordCell.shouldHighlight = true
    updates.append { state in
      passwordCell.detailTextLabel?.text = state.password
    }
    
    
    let passwordDriver = PasswordDriver(password: state.password) { newPassword in
      change({ $0.password = newPassword })
    }
    passwordCell.didSelect = {
      pushViewController(passwordDriver.formViewController)
    }
    
    let toggleSection = Section(cells: [toggleCell], footerTitle: state.enabledSectionTitle)
    updates.append { state in
      toggleSection.footerTitle = state.enabledSectionTitle
    }
    
    return (
      [toggleSection,
       Section(cells: [
        passwordCell
       ], footerTitle: nil),],
      
      Observer(strongReferences: strongReferences) { state in
        for u in updates {
          u(state)
        }
      }
    )
  }


  class FormDriver {
    var formViewController: FormViewController!
    var sections: [Section] = []
    var observer: Observer!
    
    init(initial state: Hotspot,
         build: (Hotspot,
                 @escaping ((inout Hotspot) -> ()) -> (),
                 _ pushViewController:  @escaping (UIViewController) -> ())
          -> ([Section], Observer)
    ) {
      
      self.state = state
      let (sections, observer) = build(state, { [unowned self] f in
        f(&self.state)
      }, { [unowned self] vc in
        self.formViewController.navigationController?.pushViewController(vc, animated: true)
      })
      
      self.sections = sections
      self.observer = observer
      formViewController = FormViewController(sections: sections, title: "Personal Hotspot Settings")
    }
    
    var state = Hotspot() {
      didSet {
        observer.update(state)
        formViewController.reloadSectionFooters()
      }
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

//MARK: - Forms
  class Section {
    let cells: [FormCell]
    var footerTitle: String?
    init(cells: [FormCell], footerTitle: String?) {
      self.cells = cells
      self.footerTitle = footerTitle
    }
  }

  class FormCell: UITableViewCell {
    var shouldHighlight = false
    var didSelect: (() -> ())?
  }

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
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      firstResponder?.becomeFirstResponder()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
      return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return sections[section].cells.count
    }
    
    func cell(for indexPath: IndexPath) -> FormCell {
      return sections[indexPath.section].cells[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      return cell(for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
      return cell(for: indexPath).shouldHighlight
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
      return sections[section].footerTitle
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      cell(for: indexPath).didSelect?()
    }
  }


}
