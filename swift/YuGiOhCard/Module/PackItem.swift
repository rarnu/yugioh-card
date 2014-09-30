import UIKit


class PackageCards: NSObject {
    var name = ""
    var cards = NSMutableArray()
}


class PackageDetail: NSObject {

    var packId = ""
    var packName = ""
    
    init(packId: String, packageName: String) {
        self.packId = packId
        self.packName = packageName
    }
}


class PackItem: NSObject {
    var serial = ""
    var packages = NSMutableArray()

    func addPackage(item: PackageDetail) {
        self.packages.addObject(item)
    }
}
