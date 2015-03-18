import UIKit

class SearchResultViewController: UITableViewController {
    
    var searchCardName: String?
    var searchCamp: String?
    var searchCardType: String?
    var searchSubType: String?
    var searchRace: String?
    var searchAttribute: String?
    var searchLevel: String?
    var searchRare: String?
    var searchLimit: String?
    var searchAtk: String?
    var searchDef: String?
    var searchEffect: String?
    
    var lblNoCard: UILabel?
    var _cards: NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = STR_RESULT
        var lblTop = (self.tableView.frame.size.height - 100) / 2
        lblNoCard = UILabel(frame: CGRectMake(0, lblTop, self.tableView.frame.size.width, 50))
        lblNoCard!.text = STR_NO_CARD_FOUND
        lblNoCard!.textAlignment = NSTextAlignment.Center
        lblNoCard!.textColor = UIColor.whiteColor()
        lblNoCard!.backgroundColor = UIColor.clearColor()
        lblNoCard!.hidden = true
        self.tableView.addSubview(lblNoCard!)
        
        var sql = self.buildSql()
        self._cards = DatabaseUtils.queryData(sql)
        if (self._cards!.count == 0) {
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._cards!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        var item = self._cards![indexPath.row] as CardItem
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.textLabel!.text = item.name
        cell.detailTextLabel!.text = item.sCardType
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        var item = self._cards![indexPath.row] as CardItem
        PushUtils.pushCard(item, navController: self.navigationController!)
    }
    
    func buildSql() -> String {
        var sql = "select _id, name, sCardType from YGODATA where 1=1"
        // name
        if (self.searchCardName != nil && self.searchCardName! != "") {
            sql += " and (name like '%\(self.searchCardName!)%' or japName like '%\(self.searchCardName!)%' or enName like '%\(self.searchCardName!)%' or shortName like '%\(self.searchCardName!)%' or oldName like '%\(self.searchCardName!)%')"
        }
        // camp
        if (self.searchCamp != nil && self.searchCamp! != "" && self.searchCamp! != CardConsts.campDefault()) {
            sql += " and cardCamp='\(self.searchCamp!)'"
        }
        // card type
        if (self.searchCardType != nil && self.searchCardType! != "" && self.searchCardType! != CardConsts.cardTypeDefault()) {
            sql += " and sCardType like '%\(self.searchCardType!)%'"
            
            if ((self.searchCardType! as NSString).rangeOfString(CardConsts.cardMonsterDefault()).location != NSNotFound) {
                // sub type
                if (self.searchSubType != nil && self.searchSubType! != "" && self.searchSubType! != CardConsts.cardSubTypeDefault()) {
                    sql += " and CardDType like '%\(self.searchSubType!)%'"
                }
            }
        }
        // attribute
        if (self.searchAttribute != nil && self.searchAttribute! != "" && self.searchAttribute! != CardConsts.cardAttributeDefault()) {
            sql += " and element='\(self.searchAttribute!)'"
        }
        // race
        if (self.searchRace != nil && self.searchRace! != "" && self.searchRace! != CardConsts.cardRaceDefault()) {
            sql += " and tribe='\(self.searchRace!)'"
        }
        // level
        if (self.searchLevel != nil && self.searchLevel! != "" && self.searchLevel! != CardConsts.cardLevelDefault()) {
            sql += " and level=\(self.searchLevel!)"
        }
        // rare
        if (self.searchRare != nil && self.searchRare! != "" && self.searchRare! != CardConsts.cardRareDefault()) {
            sql += " and infrequence like '%\(self.searchRare!)%'"
        }
        // limit
        if (self.searchLimit != nil && self.searchLimit! != "" && self.searchLimit! != CardConsts.cardLimitDefault()) {
            sql += " and ban='\(self.searchLimit!)'"
        }
        // atk
        if (self.searchAtk != nil && self.searchAtk! != "") {
            sql += " and atk='\(self.searchAtk!)'"
        }
        // def
        if (self.searchDef != nil && self.searchDef! != "") {
            sql += " and def='\(self.searchDef!)'"
        }
        // effect
        if (self.searchEffect != nil && self.searchEffect! != "") {
            sql += " and effect like '%\(self.searchEffect!)%'"
        }
        return sql
    }
}
