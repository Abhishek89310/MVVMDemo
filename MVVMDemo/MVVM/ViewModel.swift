import Foundation

protocol ListViewModelDelegate: AnyObject {
    func didFetchListData()
    func failedToFetchListData(error: Error)
}

class ListViewModel {
    private let api: ListAPI
    private var list: [ListModel] = []

    weak var delegate: ListViewModelDelegate?

    init(api: ListAPI) {
        self.api = api
    }

    func fetchListData() {
        api.fetchListData { [weak self] items, error in
            guard let self = self else { return }
            if let error = error {
                self.delegate?.failedToFetchListData(error: error)
                return
            }

            if let items = items {
                self.list = items
                self.delegate?.didFetchListData()
            }
        }
    }

    func numberOfItems() -> Int {
        return list.count
    }

    func item(at index: Int) -> ListModel {
        return list[index]
    }
}

