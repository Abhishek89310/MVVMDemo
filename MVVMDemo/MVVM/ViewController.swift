import UIKit
import CoreData

class ViewController: UIViewController {
    private var tableView: UITableView!

    private var viewModel: ListViewModel!
    var people: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupTableView()
        viewModel.fetchListData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }

    private func setupViewModel() {
       let api = ListAPI()
       viewModel = ListViewModel(api: api)
        viewModel.delegate = self
    }

    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        self.title = "MVVM"
        view.addSubview(tableView)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    
    @objc func addButtonTapped() {
        // Create and configure an alert controller with a text field
        let alertController = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter item name"
        }
        
        // Add actions for adding and cancelling
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let itemName = alertController.textFields?.first?.text else { return }
            guard let textField = alertController.textFields?.first,
                let nameToSave = textField.text else {
                  return
              }
              
              self.save(name: nameToSave)

            // Handle adding the item here
            // For example, you can add the item to your data source and reload the table view
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        // Present the alert controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    func save(name: String) {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // 1
        let managedContext =
        appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
        NSEntityDescription.entity(forEntityName: "Person",
                                   in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        person.setValue(name, forKeyPath: "name")
        
        // 4
        do {
            try managedContext.save()
            people.append(person)
            tableView.reloadData()
            print(people)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchData(){
          guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
              return
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          //2
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Person")
          
          //3
          do {
            people = try managedContext.fetch(fetchRequest)
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
          }
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        cell.selectionStyle = .none
        let item = person.value(forKeyPath: "name") as? String
        cell.textLabel?.text = item
        return cell
    }
}

extension ViewController: ListViewModelDelegate {
    func didFetchListData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func failedToFetchListData(error: Error) {
        print("Error fetching list data: \(error)")
        // Handle error presentation if needed
    }
}

