import UIKit

class ViewController: UIViewController {
    private var tableView: UITableView!

    private var viewModel: ListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupTableView()
       // viewModel.fetchListData()
    }

    private func setupViewModel() {
//        let api = ListAPI()
//        viewModel = ListViewModel(api: api)
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
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        let item = viewModel.item(at: indexPath.row)
        cell.textLabel?.text = item.name
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

