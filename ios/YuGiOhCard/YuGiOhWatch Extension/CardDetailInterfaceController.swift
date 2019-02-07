//
//  CardDetailInterfaceController.swift
//  YuGiOhWatch Extension
//
//  Created by rarnu on 2019/2/7.
//  Copyright © 2019 rarnu. All rights reserved.
//

import WatchKit
import Foundation


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
    
    private var hashid = ""
    private var info: CardDetail?
    
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
        let url = "https://www.ourocg.cn//card/\(hashid)"
        let req = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: req) { data, resp, err in
            self.lblLoading.setHidden(true)
            if (err != nil) {
                return
            }
            if (data != nil) {
                let html = String(data: data!, encoding: .utf8)
                self.info = YGOData.cardDetail(html)
                self.buildCardDetail()
            }
        }
        task.resume()
    }
    
    private func buildCardDetail() {
        if (info != nil) {
            lblNameCn.setText(info!.name)
            lblNameJp.setText(info!.japname)
            lblNameEn.setText(info!.enname)
            lblCardType.setText(info!.cardtype)
            if (info!.cardtype.contains("怪兽")) {
                lblMonsterRA.setText("\(info!.race!) / \(info!.element!)")
                if (info!.cardtype.contains("连接")) {
                    lblMonsterLRAD.setText("\(info!.atk!)")
                    lblMonsterLink.setText("\(info!.link!) / \(info!.linkarrow!)")
                } else {
                    lblMonsterLRAD.setText("\(info!.level!) / \(info!.atk!) / \(info!.def!)")
                }
                
            }
            lblEffect.setText(info?.effect)
            lblLoadingImage.setHidden(false)
            queryCardImage()
        }
    }
    
    private func queryCardImage() {
        // hashid
        let imgid = info!.imageId
        let localfile = documentPath(true) + "\(imgid)"
        let mgr = FileManager.default
        if (mgr.fileExists(atPath: localfile)) {
            self.lblLoadingImage.setHidden(true)
            loadLocalImage(localfile)
        } else {
            Thread.detachNewThread {
                do {
                    let imgData = try Data(contentsOf: URL(string: "http://ocg.resource.m2v.cn/\(imgid).jpg")!)
                    (imgData as NSData).write(toFile: localfile, atomically: true)
                } catch {
                    
                }
                OperationQueue.main.addOperation {
                    self.lblLoadingImage.setHidden(true)
                    if (mgr.fileExists(atPath: localfile)) {
                        self.loadLocalImage(localfile)
                    }
                }
            }
        }
    }
    
    private func loadLocalImage(_ path: String) {
        do {
            let imgData = try NSData(contentsOfFile: path) as Data
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
