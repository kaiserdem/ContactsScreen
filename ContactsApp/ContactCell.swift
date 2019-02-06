//
//  ContactCell.swift
//  ContactsApp
//
//  Created by Kaiserdem on 05.02.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
  
  var link: ViewController!
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    let  starButton = UIButton(type: .system)
    starButton.setImage(#imageLiteral(resourceName: "star.png"), for: .normal)
    starButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    starButton.tintColor = .red
    starButton.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
    accessoryView = starButton
  }
  @objc func handleMarkAsFavorite() {
    link?.someMethodIWantToCell(cell: self)
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
