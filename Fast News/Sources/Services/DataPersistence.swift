//
//  DataPersistence.swift
//  Fast News
//
//  Created by Pablo Henrique Borsone on 15/11/20.
//  Copyright © 2020 Lucas Moreton. All rights reserved.
//

import Foundation

class DataPersistence {
    
    static let shared: DataPersistence = DataPersistence()
    
    var filePath: String {
         let manager = FileManager.default
         let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
         
         return (url?.appendingPathComponent("Data").path) ?? ""
     }
    
    func saveData(items: [HotNews]) {
        do {
            // Not working yet, invalid type
            try NSKeyedArchiver.archivedData(withRootObject: items, requiringSecureCoding: false)
        } catch {
            print("Could not save data because of the following error: \(error.localizedDescription)")
        }
    }
    
    func loadData() -> [HotNews]? {
          do {
              let data = try Data(contentsOf: URL(string: filePath)!)
              let object = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
              return object as? [HotNews]
          } catch {
              print("error is: \(error.localizedDescription)")
          }
          return nil
    }
}
