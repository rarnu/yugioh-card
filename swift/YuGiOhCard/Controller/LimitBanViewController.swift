import UIKit

class LimitBanViewController: UITableViewController {

    var _cards: NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._cards = DatabaseUtils.queryBanCards()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._cards!.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated:false)
        let item = self._cards![indexPath.row] as! CardItem
        PushUtils.pushCard(item: item, navController:self.navigationController!)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath)
        let item = self._cards![indexPath.row] as! CardItem
        cell.backgroundColor = UIColor.clear()
        cell.textLabel!.textColor = UIColor.white()
        cell.textLabel!.text = item.name
        cell.detailTextLabel!.text = item.sCardType
        return cell
    }

}
