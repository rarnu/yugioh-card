//
//  CardDetailInterfaceController.swift
//  YuGiOhWatch Extension
//
//  Created by rarnu on 2019/2/7.
//  Copyright © 2019 rarnu. All rights reserved.
//

import WatchKit
import Foundation
import YGOAPI2Watch

class CardDetailInterfaceController: WKInterfaceController {

    @IBOutlet var lblLoading: WKInterfaceLabel!
    @IBOutlet var lblLoadingImage: WKInterfaceLabel!
    @IBOutlet var lblNameCn: WKInterfaceLabel!
    @IBOutlet var lblNameJp: WKInterfaceLabel!
    @IBOutlet var lblNameEn: WKInterfaceLabel!
    @IBOutlet var lblCardType: WKInterfaceLabel!
    @IBOutlet var lblMonsterRA: WKInterfaceLabel!   // race / attr
    @IBOutlet var lblMonsterLRAD: WKInterfaceLabel! // level / rank / atk / def
    @IBOutlet var lblMonsterLink: WKInterfaceLabel! // link / arrow
    @IBOutlet var lblEffect: WKInterfaceLabel!
    @IBOutlet var ivCardFace: WKInterfaceImage!
    @IBOutlet var lblAdjust: WKInterfaceLabel!
    
    private var hashid = ""
    private var info: CardDetail2?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        hashid = context as! String
        queryCardDetail()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    private func queryCardDetail() {
        Thread.detachNewThread {
            YGOData2.cardDetail(self.hashid) { c in
                self.info = c
                self.lblLoading.setHidden(true)
                self.buildCardDetail()
            }
        }
    }
    
    private func buildCardDetail() {
        if (info != nil) {
            lblNameCn.setText(info!.name)
            lblNameJp.setText(info!.japname)
            lblNameEn.setText(info!.enname)
            lblCardType.setText(info!.cardtype)
            if (info!.cardtype.contains("怪兽")) {
                lblMonsterRA.setText("\(info!.race) / \(info!.element)")
                if (info!.cardtype.contains("连接")) {
                    lblMonsterLRAD.setText("\(info!.atk)")
                    lblMonsterLink.setText("\(info!.link) / \(info!.linkarrow)")
                } else {
                    lblMonsterLRAD.setText("\(info!.level) / \(info!.atk) / \(info!.def)")
                }
                
            }
            lblEffect.setText(info?.effect)
            lblLoadingImage.setHidden(false)
            queryCardImage()
            lblAdjust.setText(info!.adjust)
        }
    }
    
    private func queryCardImage() {
        let imgid = info!.imageId
        let localfile = documentPath(true) + "\(imgid)"
        let mgr = FileManager.default
        if (mgr.fileExists(atPath: localfile)) {
            self.lblLoadingImage.setHidden(true)
            loadLocalImage(localfile)
        } else {
            downloadImage(imgid, localfile)
        }
    }
    
    private func downloadImage(_ imgid: Int, _ localfile: String) {
        let req = URLRequest(url: URL(string: "http://ocg.resource.m2v.cn/\(imgid).jpg")!)
        let task = URLSession.shared.dataTask(with: req) { data, resp, err in
            self.lblLoadingImage.setHidden(true)
            if (err == nil && data != nil) {
                let str = String(data: data!, encoding: .utf8)
                if (str == nil) {
                    (data! as NSData).write(toFile: localfile, atomically: true)
                }
            }
            self.loadLocalImage(localfile)
        }
        task.resume()
    }
    
    private func loadLocalImage(_ path: String) {
        do {
            var imgData: Data!
            if (FileManager.default.fileExists(atPath: path)) {
                imgData = try NSData(contentsOfFile: path) as Data
                ivCardFace.setImageData(imgData)
            } else {
                let img0 = Bundle.main.path(forResource: "img0", ofType: "png")!
                imgData = try NSData(contentsOfFile: img0) as Data
            }
            ivCardFace.setImageData(imgData)
            ivCardFace.setHidden(false)
        } catch {
            
        }
    }
    
    private func documentPath(_ withSeparator: Bool = false) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        var p = paths[0]
        if (withSeparator) {
            p += "/"
        }
        return p
    }
}
