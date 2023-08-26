//
//  ViewController.swift
//  MVVMDemo
//
//  Created by Matrix on 26/08/23.
//

import UIKit

class ViewController: UIViewController {

    var tableView: UITableView!
    var vmodel = viewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewAndUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        vmodel.fetchAndMapData()
        //reloading the tableview after loading the data
        vmodel.reloadTable = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func setupTableViewAndUI() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        view.addSubview(tableView)
        self.title = "MVVM"
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vmodel.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        
        let item = vmodel.list[indexPath.row]
        
        // Configure the cell with the data
        cell.textLabel?.text = item.title
        return cell
    }
}
