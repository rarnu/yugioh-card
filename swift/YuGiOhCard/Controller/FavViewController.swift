import UIKit

class FavViewController: UITableViewController {

    var lblNoCard: UILabel?
    var _cards: NSMutableArray?
    
    override func viewWillAppear(animated: Bool) {
        UIUtils.setStatusBar(true)
        UIUtils.setNavBar(self.navigationController!.navigationBar)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _cards = NSMutableArray()
        var lblTop = (self.tableView.frame.size.height - 100) / 2
        lblNoCard = UILabel(frame: CGRectMake(0, lblTop, self.tableView.frame.size.width, 50))
        lblNoCard!.text = STR_NO_CARD_COLLECTED
        lblNoCard!.textColor = UIColor.whiteColor()
        lblNoCard!.backgroundColor = UIColor.clearColor()
        lblNoCard!.textAlignment = NSTextAlignment.Center
        lblNoCard!.hidden = true
        self.tableView.addSubview(lblNoCard!)
    }
    
    override func viewDidAppear(animated: Bool) {
        var ids = DatabaseUtils.favQuery()
        _cards = DatabaseUtils.queryCardsViaIds(ids!)
        self.tableView.reloadData()
        if (_cards!.count == 0) {
            lblNoCard!.hidden = false
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        } else {
            lblNoCard!.hidden = true
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        }
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _cards!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath) as UITableViewCell
        var item = self._cards![indexPath.row] as CardItem
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.textLabel!.text = item.name
        cell.detailTextLabel!.text = item.sCardType
        return cell
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated:false)
        var item = self._cards![indexPath.row] as CardItem
        PushUtils.pushCard(item, navController:self.navigationController!)
    }
    
}
