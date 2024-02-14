import Foundation

class ListAPI{
    // Replace this URL with your actual API endpoint
    private let apiUrl = "https://api.example.com/list"

    // Dummy data for demonstration purposes
    private let dummyData: [[String: Any]] = [
        ["id": "1", "name": "Item 1"],
        ["id": "2", "name": "Item 2"],
        // Add more dummy data as needed
    ]

    func fetchListData(completion: @escaping ([ListModel]?, Error?) -> Void) {
        // In a real-world scenario, you would make an HTTP request here.
        // For simplicity, we'll use dummy data.

        // Deserialize dummy data into ListModel objects
        let items = dummyData.compactMap { itemData -> ListModel? in
            guard
                let id = itemData["id"] as? String,
                let name = itemData["name"] as? String
            else {
                return nil
            }

            return ListModel(title: id, name: name)
        }

        // Simulate network delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            // Invoke completion handler on the main thread
            DispatchQueue.main.async {
                completion(items, nil)
            }
        }
    }
}
