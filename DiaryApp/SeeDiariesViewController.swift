import Foundation
import UIKit

class SeeDiariesViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var diaries: [Diary] = [] {
        didSet {
            if let tableView = tableView {
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func back() {
        dismiss(animated: true, completion: nil)
    }
}

extension SeeDiariesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryCell") as! DiaryTableViewCell
        cell.setup(diary: diaries[indexPath.row])
        return cell
    }
}
