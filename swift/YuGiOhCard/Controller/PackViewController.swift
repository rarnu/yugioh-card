import UIKit

class PackViewController: UITableViewController, HttpUtilsDelegate {

    @IBOutlet var refreshButton: UIBarButtonItem?
    
    var _packages: String?
    var _data_path: String?
    var _section_count: Int?
    var _pack_section: NSMutableArray?
    
    override func viewWillAppear(animated: Bool) {
        UIUtils.setStatusBar(true)
        UIUtils.setNavBar(self.navigationController!.navigationBar)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _packages = "packages"
        _data_path = "data"
        _pack_section = NSMutableArray()

        let jsonData = FileUtils.readTextFile(_packages!, loadPath:_data_path!)
        if (jsonData == "") {
            let hu = HttpUtils()
            hu.delegate = self
            hu.get(URL_PACKAGES)
        } else {
            self.loadData(jsonData)
        }
        self.refreshButton!.target = self
        self.refreshButton!.action = #selector(PackViewController.refreshClicked(_:))
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func refreshClicked(sender: AnyObject) {
        let hu = HttpUtils()
        hu.delegate = self
        hu.get(URL_PACKAGES)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return _pack_section!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (_pack_section![section] as! PackItem).packages.count
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lblSection = UILabel()
        lblSection.text = "  \((_pack_section![section] as! PackItem).serial)"
        lblSection.textColor = UIColor.whiteColor()
        lblSection.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        return lblSection
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath) 
        let item = (_pack_section![indexPath.section] as! PackItem).packages[indexPath.row] as! PackageDetail
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.textLabel!.text = item.packName
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated:false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "pushPack") {
            let index = self.tableView.indexPathForSelectedRow
            let item = (_pack_section![index!.section] as! PackItem).packages[index!.row] as! PackageDetail
            (segue.destinationViewController as! PackDetailViewController).packageId = item.packId
            (segue.destinationViewController as! PackDetailViewController).packageName = item.packName
        }
    }

    
    func httpUtils(httpUtils: HttpUtils, receivedData data: NSData?) {
        if (data != nil) {
            let json = NSString(data: data!, encoding:NSUTF8StringEncoding) as! String
            FileUtils.writeTextFile(_packages!, savePath:_data_path!, fileContent:json)
            self.loadData(json)
        }
    }

    func httpUtils(httpUtils: HttpUtils, receivedError err: NSString) {
        
    }
    
    func loadData(jsonData: String) {
    // load json data
        let data = (jsonData as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        let packs = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves)) as! NSArray
        var pack: AnyObject? = nil
        var arrPack: NSArray?
        var packDetail: AnyObject? = nil
        for i in 0 ..< packs.count {
            pack = packs[i]
            let item = PackItem()
            item.serial = (pack! as! NSDictionary).objectForKey("serial") as! String
            arrPack = (pack! as! NSDictionary).objectForKey("packages") as? NSArray
            for j in 0 ..< arrPack!.count {
                packDetail = arrPack![j]
                item.packages.addObject(PackageDetail(
                    packId: (packDetail as! NSDictionary).objectForKey("id") as! String,
                    packageName: (packDetail as! NSDictionary).objectForKey("packname") as! String)
                )
            }
            _pack_section!.addObject(item)
        }
        self.tableView.reloadData()
    }


}
