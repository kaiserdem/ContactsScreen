//
//  ViewController.swift
//  ContactsApp
//
//  Created by Kaiserdem on 03.02.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UITableViewController {

  let cellId = "cellId"
  
  func someMethodIWantToCell(cell: UITableViewCell) {
                // индекс нажатой ячейки
    guard let indexPathTapped = tableView.indexPath(for: cell) else { return }
    let contact = twoDimensionalArray[indexPathTapped.section].names[indexPathTapped.row]
    print(contact)
    let hasFavorited = contact.hasFavorited
      twoDimensionalArray[indexPathTapped.section].names[indexPathTapped.row].hasFavorited = !hasFavorited
    cell.accessoryView?.tintColor = hasFavorited ? UIColor.lightGray : .red
  }
  var twoDimensionalArray = [ExpendableNames]()
//  var twoDimensionalArray = [
//    ExpendableNames(isExpanded: true, names: ["Philip", "Bill", "Olya", "Jack", "Leo"].map{ FavoritableContact(name: $0, hasFavorited: false)}),
//    ExpendableNames(isExpanded: true, names: ["Smith", "Johnson", "Williams", "Jones", "Brown", "Davis", "Miller"].map{ FavoritableContact(name: $0, hasFavorited: false)}),
//    ExpendableNames(isExpanded: true, names: ["Amy", "Moore", "Leo"].map{ FavoritableContact(name: $0, hasFavorited: false)}),
//    ExpendableNames(isExpanded: true, names: ["Steve", "Greg", "Greg", "Oleg", "Lena"].map{ FavoritableContact(name: $0, hasFavorited: false)}),
//    ExpendableNames(isExpanded: true, names: [FavoritableContact(name: "Philip", hasFavorited: false)])
//    ]
  
  private func fetchContacts() { // получить доступ к контактам
    let store = CNContactStore()
    store.requestAccess(for: .contacts) { (granted, err) in //запрос доступа
      if let err = err {
        print(err)
        return
      }
      if granted { // предоставляються
        print("Access granted")
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        
        do {
          var favoritableContacts = [FavoritableContact]()
          try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToEnumerating) in
            print(contact.givenName)
            print(contact.familyName)
            print(contact.phoneNumbers.first?.value.stringValue ?? "")
            
            favoritableContacts.append(FavoritableContact(contact: contact, hasFavorited: false))
            
          })
          
          let names = ExpendableNames(isExpanded: true, names: favoritableContacts)
          self.twoDimensionalArray = [names]
          
        }catch let err {
          print("Failed to enumerate contacts:", err)
        }
      } else {
        print("Access denied") // отказ

      }
    }
  }
  var showIndexPaths = false
  
  @objc func handleShowIndexPath() {
    var indexPathToReload = [IndexPath]()
    
    for section in twoDimensionalArray.indices {
      for row in twoDimensionalArray[section].names.indices{
        print(section, row)
        let indexPath = IndexPath(row: row, section: section)
        indexPathToReload.append(indexPath)
      }
    }
    showIndexPaths = !showIndexPaths
    // анимауия меняеться
    let animationStyle = showIndexPaths ? UITableView.RowAnimation.right : .left
    
    tableView.reloadRows(at: indexPathToReload, with: animationStyle)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fetchContacts()
    navigationItem.title = "Contacts"
    navigationController?.navigationBar.prefersLargeTitles = true
    // переиспользовать ячйку класса
    tableView.register(ContactCell.self, forCellReuseIdentifier: cellId)
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show indexPath", style: .plain, target: self, action: #selector(handleShowIndexPath))
  }
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let button = UIButton(type: .system) // хедер это кнопка
    button.setTitle("Close", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.backgroundColor = .yellow
    button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
    button.tag = section
    return button
    
  }
  @objc func handleExpandClose(button: UIButton) {
    print("Trying to expanding and close section...")
    let section = button.tag // текущий индекс
    var indexPaths = [IndexPath]()
    for row in twoDimensionalArray[section].names.indices {
      print(0, row)
      let indexPath = IndexPath(row: row, section: section)
      indexPaths.append(indexPath)
    }
    let isExpended = twoDimensionalArray[section].isExpanded
    twoDimensionalArray[section].isExpanded = !isExpended
    button.setTitle(isExpended ? "Open" : "Close", for: .normal)
      if isExpended {    // удалить
        tableView.deleteRows(at: indexPaths, with: .fade)
      } else {         // добавить
        tableView.insertRows(at: indexPaths, with: .fade)
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 43
  }
                        // кол секций
  override func numberOfSections(in tableView: UITableView) -> Int {
    return twoDimensionalArray.count
  }                     // ячеек в секции
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if !twoDimensionalArray[section].isExpanded {
      return 0
    }
    return twoDimensionalArray[section].names.count
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = ContactCell(style: .subtitle, reuseIdentifier: cellId)
    cell.link = self
    
    let favoritableContact = twoDimensionalArray[indexPath.section].names[indexPath.row]
    cell.textLabel?.text = favoritableContact.contact.givenName + " " + favoritableContact.contact.familyName
    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    cell.detailTextLabel?.text = favoritableContact.contact.phoneNumbers.first?.value.stringValue
    cell.accessoryView?.tintColor = favoritableContact.hasFavorited ? UIColor.red : .lightGray
    if showIndexPaths {

    }
    return cell
  }

}

