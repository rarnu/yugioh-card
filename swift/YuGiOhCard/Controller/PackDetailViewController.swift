import UIKit

class PackDetailViewController: UITableViewController, HttpUtilsDelegate {

    @IBOutlet var refreshButton: UIBarButtonItem?
    var packageId: String?
    var packageName: String?
    
    var _packages: String?
    var _data_path: String?
    var _pack_cards: PackageCards?
    var _cards: NSMutableArray?
    
    override func viewWillAppear(animated: Bool) {
        UIUtils.setStatusBar(true)
        UIUtils.setNavBar(self.navigationController!.navigationBar)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.packageName!
        _packages = "\(self.packageId).pkg"
        _data_path = "data"
        _pack_cards = PackageCards()
        _cards = NSMutableArray()
        let jsonData = FileUtils.readTextFile(_packages!, loadPath:_data_path!)
        if (jsonData == "") {
            let hu = HttpUtils()
            hu.delegate = self
            let packageCardUrl = NSString(format: URL_PACAKGE_CARD, self.packageId!) as String
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
        let hu = HttpUtils()
        hu.delegate = self
        let packageCardUrl = NSString(format: URL_PACAKGE_CARD, self.packageId!) as String
        hu.get(packageCardUrl)
    }
    
    func httpUtils(httpUtils: HttpUtils, receivedData data: NSData?) {
        if (data != nil) {
            let json = NSString(data: data!, encoding:NSUTF8StringEncoding)
            FileUtils.writeTextFile(_packages!, savePath:_data_path!, fileContent:json as! String)
            self.loadData(json as! String)
        }
    }
    
    func httpUtils(httpUtils: HttpUtils, receivedError err: NSString) {
        
    }
    
    func loadData(json: String) {
        let data = (json as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        let pack: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableLeaves)
        if (pack != nil) {
            _pack_cards!.name = (pack! as! NSDictionary).objectForKey("name") as! String
            _pack_cards!.cards.removeAllObjects()
            _pack_cards!.cards.addObjectsFromArray((pack! as! NSDictionary).objectForKey("cards") as! [AnyObject])
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
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath) 
        let item = _cards![indexPath.row] as! CardItem
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.textLabel!.text = item.name
        cell.detailTextLabel!.text = item.sCardType
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated:false)
        let item = _cards![indexPath.row] as! CardItem
        PushUtils.pushCard(item, navController:self.navigationController!)
    }
    
}
