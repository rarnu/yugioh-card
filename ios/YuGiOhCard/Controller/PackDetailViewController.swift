import UIKit

class PackDetailViewController: UITableViewController, HttpUtilsDelegate {

    @IBOutlet var refreshButton: UIBarButtonItem?
    var packageId: String?
    var packageName: String?
    
    var _packages: String?
    var _data_path: String?
    var _pack_cards: PackageCards?
    var _cards: NSMutableArray?
    
    override func viewWillAppear(_ animated: Bool) {
        UIUtils.setStatusBar(light: true)
        UIUtils.setNavBar(nav: self.navigationController!.navigationBar)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.packageName!
        _packages = "\(String(describing: self.packageId)).pkg"
        _data_path = "data"
        _pack_cards = PackageCards()
        _cards = NSMutableArray()
        let jsonData = FileUtils.readTextFile(fileName: _packages!, loadPath:_data_path!)
        if (jsonData == "") {
            let hu = HttpUtils()
            hu.delegate = self
            let packageCardUrl = String(format: URL_PACAKGE_CARD, self.packageId!)
            hu.get(url: packageCardUrl)
        } else {
            self.loadData(json: jsonData)
        }
        
        self.refreshButton!.target = self
        self.refreshButton!.action = #selector(refreshClicked(sender:))
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func refreshClicked(sender: AnyObject) {
        let hu = HttpUtils()
        hu.delegate = self
        let packageCardUrl = String(format: URL_PACAKGE_CARD, self.packageId!)
        hu.get(url: packageCardUrl)
    }
    
    func httpUtils(httpUtils: HttpUtils, receivedData data: NSData?) {
        if (data != nil) {
            let json = NSString(data: data! as Data, encoding:String.Encoding.utf8.rawValue)
            FileUtils.writeTextFile(fileName: _packages!, savePath:_data_path!, fileContent:json! as String)
            self.loadData(json: json! as String)
        }
    }
    
    func httpUtils(httpUtils: HttpUtils, receivedError err: String) {
        
    }
    
    func loadData(json: String) {
        let data = (json as NSString).data(using: String.Encoding.utf8.rawValue)
        let pack = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves)
        if (pack != nil) {
            _pack_cards!.name = (pack! as! NSDictionary).object(forKey: "name") as! String
            _pack_cards!.cards.removeAllObjects()
            _pack_cards!.cards.addObjects(from: (pack! as! NSDictionary).object(forKey: "cards") as! [AnyObject])
            _cards = DatabaseUtils.queryCardsViaIds(cardIds: _pack_cards!.cards)
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _cards!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath)
        let item = _cards![indexPath.row] as! CardItem
        cell.backgroundColor = UIColor.clear
        cell.textLabel!.textColor = UIColor.white
        cell.textLabel!.text = item.name
        cell.detailTextLabel!.text = item.sCardType
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated:false)
        let item = _cards![indexPath.row] as! CardItem
        PushUtils.pushCard(item: item, navController:self.navigationController!)
    }
    
}
