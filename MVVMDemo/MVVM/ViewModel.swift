//
//  ViewModel.swift
//  MVVMDemo
//
//  Created by Matrix on 26/08/23.
//

import Foundation

class viewModel{
    var reloadTable:(()->())?
    var list:[listModel] = []
    
    func fetchAndMapData() {
           API().fetchListData { [weak self] items, error in
               if let error = error {
                   print("Error fetching list data: \(error)")
                   return
               }
               
               if let items = items {
                   self?.list = items
                   self?.reloadTable?()
               }
           }
       }
}
