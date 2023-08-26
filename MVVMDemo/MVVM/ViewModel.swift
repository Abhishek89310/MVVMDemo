//
//  ViewModel.swift
//  MVVMDemo
//
//  Created by Matrix on 26/08/23.
//

import Foundation

//We wrote all the bussiness logic in ViewModel in MVVM.
//Dont import UIkit on ViewModel
class viewModel{
    var reloadTable:(()->())?
    var list:[listModel] = []
    
    //fetching data from api and reloading tableview
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
