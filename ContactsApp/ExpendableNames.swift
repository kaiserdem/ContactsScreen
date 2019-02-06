//
//  ExpendableNames.swift
//  ContactsApp
//
//  Created by Kaiserdem on 05.02.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import Foundation
import Contacts

struct ExpendableNames {
  var isExpanded: Bool
  var names: [FavoritableContact]
}

struct FavoritableContact {
  let contact: CNContact
//  let name: String
//  let phoneNumber: String
//  let address: String
  var hasFavorited: Bool
}
