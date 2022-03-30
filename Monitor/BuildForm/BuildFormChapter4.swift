//
//  BuildFormChapter4.swift
//  Pods
//
//  Created by Fri on 2022/3/29.
//


import UIKit
enum BuildFormChapter4{
  //MARK: - FormViewController
  
  static func hotspotForm(context: RenderingContext<Hotspot>) -> ([Section], Observer<Hotspot>) {
    var strongReferences: [Any] = []
    var updates: [(Hotspot) -> ()] = []
    
    let toggleCell = FormCell(style: .value1, reuseIdentifier: nil)
    let toggle = UISwitch()
    toggleCell.textLabel?.text = "Personal Hotspot"
    toggleCell.contentView.addSubview(toggle)
    toggle.translatesAutoresizingMaskIntoConstraints = false
    let toggleTarget = TargetAction {
      context.change { $0.isEnabled = toggle.isOn }
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
    passwordCell.accessoryType = .disclosureIndicator
    passwordCell.shouldHighlight = true
    updates.append { state in
      passwordCell.detailTextLabel?.text = state.password
    }
    
    let (sections, observer) = buildPasswordForm(context)
    let nested = FormViewController(sections: sections, title: "Personal Hotspot Password")
    passwordCell.didSelect = {
      context.pushViewController(nested)
    }
    
    let toggleSection = Section(cells: [toggleCell], footerTitle: nil)
    updates.append { state in
      toggleSection.footerTitle = state.enabledSectionTitle
    }
    
    return ([
      toggleSection,
      Section(cells: [
        passwordCell
      ], footerTitle: nil),
    ], Observer(strongReferences: strongReferences + observer.strongReferences) { state in
      observer.update(state)
      for u in updates {
        u(state)
      }
    }
    )
  }
  
  static func buildPasswordForm(_ context: RenderingContext<Hotspot>) -> ([Section], Observer<Hotspot>) {
    let cell = FormCell(style: .value1, reuseIdentifier: nil)
    let textField = UITextField()
    cell.textLabel?.text = "Password"
    cell.contentView.addSubview(textField)
    textField.translatesAutoresizingMaskIntoConstraints = false
    let update: (Hotspot) -> () = { state in
      textField.text = state.password
    }
    
    cell.contentView.addConstraints([
      textField.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
      textField.trailingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.trailingAnchor),
      textField.leadingAnchor.constraint(equalTo: cell.textLabel!.trailingAnchor, constant: 20)
    ])
    
    
    let ta1 = TargetAction {
      context.change { $0.password = textField.text ?? "" }
    }
    let ta2 = TargetAction {
      context.change { $0.password = textField.text ?? "" }
      context.popViewController()
    }
    
    textField.addTarget(ta1, action: #selector(TargetAction.action(_:)), for: .editingDidEnd)
    textField.addTarget(ta2, action: #selector(TargetAction.action(_:)), for: .editingDidEndOnExit)
    
    return ([
      Section(cells: [cell], footerTitle: nil)
    ], Observer(strongReferences: [ta1, ta2], update: update))
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
  
  class FormDriver<State> {
    var formViewController: FormViewController!
    var sections: [Section] = []
    var observer: Observer<State>!
    
    var state: State {
      didSet {
        observer.update(state)
        formViewController.reloadSectionFooters()
      }
    }
    
    init(initial state: State, build: (RenderingContext<State>) -> ([Section], Observer<State>)) {
      self.state = state
      let context = RenderingContext(state: state, change: { [unowned self] f in
        f(&self.state)
      }, pushViewController: { [unowned self] vc in
        self.formViewController.navigationController?.pushViewController(vc, animated: true)
      }, popViewController: {
        self.formViewController.navigationController?.popViewController(animated: true)
      })
      let (sections, observer) = build(context)
      self.sections = sections
      self.observer = observer
      observer.update(state)
      formViewController = FormViewController(sections: sections, title: "Personal Hotspot Settings")
    }
  }
  
  final class TargetAction {
    let execute: () -> ()
    init(_ execute: @escaping () -> ()) {
      self.execute = execute
    }
    @objc func action(_ sender: Any) {
      execute()
    }
  }
  
  struct Observer<State> {
    var strongReferences: [Any]
    var update: (State) -> ()
  }
  
  struct RenderingContext<State> {
    let state: State
    let change: ((inout State) -> ()) -> ()
    let pushViewController: (UIViewController) -> ()
    let popViewController: () -> ()
  }
  
}
