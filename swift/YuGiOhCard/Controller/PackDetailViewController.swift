import UIKit

class PackDetailViewController: UITableViewController, HttpUtilsDelegate {

    @IBOutlet var refreshButton: UIBarButtonItem?
    var packageId: String?
    var packageName: String?
    
    var _packages: String?
    var _data_path: String?
    var _pack_cards: PackageCards?
    var _cards: NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.packageName!
        _packages = "\(self.packageId).pkg"
        _data_path = "data"
        _pack_cards = PackageCards()
        _cards = NSMutableArray()
        var jsonData = FileUtils.readTextFile(_packages!, loadPath:_data_path!)
        if (jsonData == "") {
            var hu = HttpUtils()
            hu.delegate = self
            var packageCardUrl = NSString(format: URL_PACAKGE_CARD, self.packageId!) as String
            hu.get(packageCardUrl)
        } else {
            self.loadData(jsonData)
        }
        
        self.refreshButton!.target = self
        self.refreshButton!.action = "refreshClicked:"
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshClicked(sender: AnyObject) {
        var hu = HttpUtils()
        hu.delegate = self
        var packageCardUrl = NSString(format: URL_PACAKGE_CARD, self.packageId!) as String
        hu.get(packageCardUrl)
    }
    
    func httpUtils(httpUtils: HttpUtils, receivedData data: NSData?) {
        if (data != nil) {
            var json = NSString(data: data!, encoding:NSUTF8StringEncoding)
            FileUtils.writeTextFile(_packages!, savePath:_data_path!, fileContent:json)
            self.loadData(json)
        }
    }
    
    func httpUtils(httpUtils: HttpUtils, receivedError err: NSString) {
        
    }
    
    func loadData(json: String) {
        var data = (json as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        var pack: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableLeaves, error:nil)
        if (pack != nil) {
            _pack_cards!.name = (pack! as NSDictionary).objectForKey("name") as String
            _pack_cards!.cards.removeAllObjects()
            _pack_cards!.cards.addObjectsFromArray((pack! as NSDictionary).objectForKey("cards") as NSArray)
            _cards = DatabaseUtils.queryCardsViaIds(_pack_cards!.cards)
        self.tableView.reloadData()
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _cards!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath) as UITableViewCell
        var item = _cards![indexPath.row] as CardItem
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.textLabel!.text = item.name
        cell.detailTextLabel!.text = item.sCardType
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated:false)
        var item = _cards![indexPath.row] as CardItem
        PushUtils.pushCard(item, navController:self.navigationController!)
    }
    
}
