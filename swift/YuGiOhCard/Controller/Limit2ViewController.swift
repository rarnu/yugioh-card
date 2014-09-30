import UIKit

class Limit2ViewController: UITableViewController {

    var _cards: NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._cards = DatabaseUtils.queryLimit2Cards()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._cards!.count
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated:false)
        var item = self._cards![indexPath.row] as CardItem
        PushUtils.pushCard(item, navController:self.navigationController!)
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
    
}