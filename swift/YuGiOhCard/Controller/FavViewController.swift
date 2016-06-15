import UIKit

class FavViewController: UITableViewController {

    var lblNoCard: UILabel?
    var _cards: NSMutableArray?
    
    override func viewWillAppear(_ animated: Bool) {
        UIUtils.setStatusBar(light: true)
        UIUtils.setNavBar(nav: self.navigationController!.navigationBar)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _cards = NSMutableArray()
        let lblTop = (self.tableView.frame.size.height - 100) / 2
        lblNoCard = UILabel(frame: CGRect(x: 0, y: lblTop, width: self.tableView.frame.size.width, height: 50))
        lblNoCard!.text = STR_NO_CARD_COLLECTED
        lblNoCard!.textColor = UIColor.white()
        lblNoCard!.backgroundColor = UIColor.clear()
        lblNoCard!.textAlignment = NSTextAlignment.center
        lblNoCard!.isHidden = true
        self.tableView.addSubview(lblNoCard!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let ids = DatabaseUtils.favQuery()
        _cards = DatabaseUtils.queryCardsViaIds(cardIds: ids!)
        self.tableView.reloadData()
        if (_cards!.count == 0) {
            lblNoCard!.isHidden = false
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        } else {
            lblNoCard!.isHidden = true
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        }
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _cards!.count
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated:false)
        let item = self._cards![indexPath.row] as! CardItem
        PushUtils.pushCard(item: item, navController:self.navigationController!)
    }
    
}
