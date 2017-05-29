import UIKit

class PackViewController: UITableViewController, HttpUtilsDelegate {

    @IBOutlet var refreshButton: UIBarButtonItem?
    
    var _packages: String?
    var _data_path: String?
    var _section_count: Int?
    var _pack_section: NSMutableArray?
    
    override func viewWillAppear(_ animated: Bool) {
        UIUtils.setStatusBar(light: true)
        UIUtils.setNavBar(nav: self.navigationController!.navigationBar)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _packages = "packages"
        _data_path = "data"
        _pack_section = NSMutableArray()

        let jsonData = FileUtils.readTextFile(fileName: _packages!, loadPath:_data_path!)
        if (jsonData == "") {
            let hu = HttpUtils()
            hu.delegate = self
            hu.get(url: URL_PACKAGES)
        } else {
            self.loadData(jsonData: jsonData)
        }
        self.refreshButton!.target = self
        self.refreshButton!.action = #selector(refreshClicked(sender:))
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func refreshClicked(sender: AnyObject) {
        let hu = HttpUtils()
        hu.delegate = self
        hu.get(url: URL_PACKAGES)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return _pack_section!.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (_pack_section![section] as! PackItem).packages.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lblSection = UILabel()
        lblSection.text = "  \((_pack_section![section] as! PackItem).serial)"
        lblSection.textColor = UIColor.white
        lblSection.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        return lblSection
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath)
        let item = (_pack_section![indexPath.section] as! PackItem).packages[indexPath.row] as! PackageDetail
        cell.backgroundColor = UIColor.clear
        cell.textLabel!.textColor = UIColor.white
        cell.textLabel!.text = item.packName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated:false)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "pushPack") {
            let index = self.tableView.indexPathForSelectedRow
            let item = (_pack_section![index!.section] as! PackItem).packages[index!.row] as! PackageDetail
            (segue.destination as! PackDetailViewController).packageId = item.packId
            (segue.destination as! PackDetailViewController).packageName = item.packName
        }
    }

    func httpUtils(httpUtils: HttpUtils, receivedData data: NSData?) {
        if (data != nil) {
            let json = NSString(data: data! as Data, encoding:String.Encoding.utf8.rawValue)! as String
            FileUtils.writeTextFile(fileName: _packages!, savePath:_data_path!, fileContent:json)
            self.loadData(jsonData: json)
        }
    }

    func httpUtils(httpUtils: HttpUtils, receivedError err: String) {
        
    }
    
    func loadData(jsonData: String) {
    // load json data
        let data = jsonData.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        let packs = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves)) as! NSArray
        var pack: Any? = nil
        var arrPack: NSArray?
        var packDetail: Any? = nil
        for i in 0 ..< packs.count {
            pack = packs[i]
            let item = PackItem()
            item.serial = (pack! as! NSDictionary).object(forKey: "serial") as! String
            arrPack = (pack! as! NSDictionary).object(forKey: "packages") as? NSArray
            for j in 0 ..< arrPack!.count {
                packDetail = arrPack![j]
                item.packages.add(PackageDetail(
                    packId: (packDetail as! NSDictionary).object(forKey: "id") as! String,
                    packageName: (packDetail as! NSDictionary).object(forKey: "packname") as! String)
                )
            }
            _pack_section!.add(item)
        }
        self.tableView.reloadData()
    }


}
