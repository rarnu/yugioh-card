//
//  ViewController.swift
//  YuGiOhCard
//
//  Created by rarnu on 2018/6/29.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit
import commonios
import TangramKit
import YGOAPI2

class MainController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImagePopupDelegate {

    var layMain: TGLinearLayout!
    var edtSearch: UITextField!
    var btnSearch: UIButton!
    var btnAdvSearch: UIButton!
    var btnImageSearch: UIButton!
    var laySearchKeyword: TGLinearLayout!
    var layHotCard: TGLinearLayout!
    var layLastPack: TGLinearLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sv = UIScrollView(frame: CGRect(x: 8, y: 8, width: screenWidth() - 16, height: screenHeight() - 16))
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        self.view.addSubview(sv)
        layMain = TGLinearLayout(.vert) ~>> {
            $0.tg_vspace = 0
            $0.tg_width.equal(100%)
            $0.tg_height.equal(.wrap).min(sv.tg_height, increment: 0)
            return $0
        }
        sv.addSubview(layMain)
        let v = UIView()
        v.tg_width.equal(100%)
        v.tg_height.equal(52)
        layMain.addSubview(v)
        edtSearch = UITextField(frame: CGRect(x: 0, y: 8, width: screenWidth() - 140, height: 36))
        edtSearch.textColor = UIColor.white
        edtSearch.borderStyle = UITextField.BorderStyle.none
        edtSearch.attributedPlaceholder = NSAttributedString(string: "输入要搜索的关键字", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        edtSearch.returnKeyType = UIReturnKeyType.done
        edtSearch.delegate = self
        v.addSubview(edtSearch)
        btnSearch = UIButton(type: UIButton.ButtonType.system)
        btnSearch.frame = CGRect(x: screenWidth() - 158, y: 8, width: 50, height: 36)
        btnSearch.setTitle("搜索", for: UIControl.State.normal)
        v.addSubview(btnSearch)
        
        btnAdvSearch = UIButton(type: UIButton.ButtonType.system)
        btnAdvSearch.frame = CGRect(x: screenWidth() - 108, y: 8, width: 50, height: 36)
        btnAdvSearch.setTitle("高级", for: UIControl.State.normal)
        v.addSubview(btnAdvSearch)
        
        btnImageSearch = UIButton(type: UIButton.ButtonType.system)
        btnImageSearch.frame = CGRect(x: screenWidth() - 58, y:8, width: 50, height: 36)
        btnImageSearch.setTitle("识图", for: UIControl.State.normal)
        v.addSubview(btnImageSearch)
        
        let line = UIView(frame: CGRect(x: 0, y: 44, width: screenWidth() - 16, height: 1))
        line.backgroundColor = UIColor.darkGray
        v.addSubview(line)
        let blank = UIView()
        blank.tg_width.equal(100%)
        blank.tg_height.equal(8)
        layMain.addSubview(blank)
        
        // event
        btnSearch.addTarget(self, action: #selector(btnSearchClicked(sender:)), for: UIControl.Event.touchDown)
        btnAdvSearch.addTarget(self, action: #selector(btnAdvSearchClicked(sender:)), for: UIControl.Event.touchDown)
        btnImageSearch.addTarget(self, action: #selector(btnImageSearchClicked(sender:)), for: UIControl.Event.touchDown)
        
        makeText("热门搜索")
        laySearchKeyword = makeLayout()
        makeLine()
        makeHotText("热门卡片")
        layHotCard = makeLayout()
        makeLine()
        makeText("热门卡包")
        layLastPack = makeLayout()
        makeLine()
        let btnHelp = makeButton("关于")
        btnHelp.addTarget(self, action: #selector(self.btnHelpClicked(sender:)), for: UIControl.Event.touchDown)
        
        loadHotest()
        
        Updater.checkUpdate(vc: self)
    }
    
    func makeLayout() -> TGLinearLayout {
        let lay = TGLinearLayout(.vert)
        lay.tg_vspace = 0
        lay.tg_width.equal(100%)
        lay.tg_height.equal(.wrap)
        layMain.addSubview(lay)
        return lay
    }
    
    func makeText(_ txt: String) {
        let lbl = UILabel()
        lbl.tg_width.equal(100%)
        lbl.tg_height.equal(.wrap)
        lbl.attributedText = NSAttributedString(string: txt, attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        layMain.addSubview(lbl)
        let v = UIView()
        v.tg_width.equal(100%)
        v.tg_height.equal(4)
        layMain.addSubview(v)
    }
    
    func makeHotText(_ txt: String) {
        let lay = UIView()
        lay.tg_width.equal(100%)
        lay.tg_height.equal(30)
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        lbl.attributedText = NSAttributedString(string: txt, attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        lay.addSubview(lbl)
        let change = UIButton(type: UIButton.ButtonType.system)
        change.setAttributedTitle(NSAttributedString(string: "<换一批>", attributes: [NSAttributedString.Key.underlineStyle : true]), for: UIControl.State.normal)
        change.frame = CGRect(x: screenWidth() - 100, y: 0, width: 100, height: 30)
        change.addTarget(self, action: #selector(btnChangeHotClicked(sender:)), for: UIControl.Event.touchDown)
        lay.addSubview(change)
        
        layMain.addSubview(lay)
        let v = UIView()
        v.tg_width.equal(100%)
        v.tg_height.equal(4)
        layMain.addSubview(v)
    }
    
    func makeButton(_ txt: String) -> UIButton {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.tg_width.equal(100%)
        btn.tg_height.equal(32)
        btn.setTitle(txt, for: UIControl.State.normal)
        layMain.addSubview(btn)
        return btn
    }
    
    func makeLine() {
        let v = UIView()
        v.tg_width.equal(100%)
        v.tg_height.equal(1)
        v.tg_vertMargin(8.0)
        v.backgroundColor = UIColor.darkGray
        layMain.addSubview(v)
    }
    
    func makeLabel(lay: TGLinearLayout, txt: String, hash: String, sel: Selector) {
        let l = UIButton(type: UIButton.ButtonType.system)
        l.tg_width.equal(100%)
        l.tg_height.equal(32)
        l.setTitle(txt, for: UIControl.State.normal)
        l.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        l.accessibilityValue = hash
        l.addTarget(self, action: sel, for: UIControl.Event.touchDown)
        lay.addSubview(l)
    }
    
    func makeKeyword(list: Array<String>) {
        var idx = 0
        var remain = list.count
        let w = (screenWidth() - 16) / 5
        while remain > 0 {
            let lay = TGLinearLayout(.horz)
            lay.tg_width.equal(100%)
            lay.tg_height.equal(32)
            var last = 0
            if (remain >= 5) {
                last = idx + 5
            } else {
                last = idx + remain
            }
            for i in idx ..< last {
                let v = UIButton(type: UIButton.ButtonType.system)
                v.tg_width.equal(w)
                v.tg_height.equal(32)
                v.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
                v.setTitle(list[i], for: UIControl.State.normal)
                v.addTarget(self, action: #selector(btnKeywordClicked(sender:)), for: UIControl.Event.touchDown)
                lay.addSubview(v)
            }
            if (remain >= 5) {
                idx += 5
                remain -= 5
            } else {
                idx += remain
                remain -= remain
            }
            laySearchKeyword.addSubview(lay)
        }
    }
    
    private func loadHotest() {
        laySearchKeyword.tg_removeAllSubviews()
        layHotCard.tg_removeAllSubviews()
        layLastPack.tg_removeAllSubviews()
        
        YGOData2.hostest() { h in
            mainThread {
                self.makeKeyword(list: h.search)
                for c in h.card {
                    self.makeLabel(lay: self.layHotCard, txt: c.name, hash: c.hashid, sel: #selector(self.btnHotCardClicked(sender:)))
                }
                for p in h.pack {
                    self.makeLabel(lay: self.layLastPack, txt: p.name, hash: p.packid, sel: #selector(self.btnHotPackClicked(sender:)))
                }
                
            }
        }
    }
    
    @objc func btnChangeHotClicked(sender: Any) {
        loadHotest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func btnSearchClicked(sender: Any) {
        // search clicked
        let key = edtSearch.text
        if (key == nil || key == "") {
            toast(msg: "不能搜索空关键字")
            return
        }
        let c = vc(name: "cardlist") as! CardListController
        c.key = key!
        navigationController?.pushViewController(c, animated: true)
    }
    
    @objc func btnAdvSearchClicked(sender: Any) {
        let c = vc(name: "search") as! SearchController
        navigationController?.pushViewController(c, animated: true)
    }
    
    
    @objc func btnImageSearchClicked(sender: Any) {
        
        // TODO: image search
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { _ in }))
        alert.addAction(UIAlertAction(title: "拍照", style: UIAlertAction.Style.default, handler: { action in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerController.SourceType.camera
            self.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "从相册选取", style: UIAlertAction.Style.default, handler: { action in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: picker.sourceType)!
            picker.allowsEditing = false
            self.present(picker, animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func findImageHash(_ imgid: String) {
        YGOData2.findImageByImageId(imgid) { (hash, name) in
            mainThread {
                if (hash == "") {
                    toast(msg: "没有匹配的卡片.")
                } else {
                    let c = self.vc(name: "detail") as! CardDetailController
                    c.cardname = name
                    c.hashid = hash
                    self.navigationController?.pushViewController(c, animated: true)
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let type = info[UIImagePickerController.InfoKey.mediaType] as! String
        if (type == "public.image") {
            toast(msg: "正在上传图片，请稍候...")
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let data = image.jpegData(compressionQuality: 1.0)
            let path = "\(documentPath())/tmp.jpg"
            FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
            YGOData2.imageSearch(path) { imgids in
                mainThread {
                    if (imgids.count == 0) {
                        toast(msg: "没有匹配的卡片.")
                    } else if (imgids.count == 1) {
                        self.findImageHash(imgids[0])
                    } else {
                        // 找到多张图
                        let w = (screenWidth() * 0.8 - 32) / 5
                        let h = 23 * w / 16
                        let lines = imgids.count / 5 + (imgids.count % 5 != 0 ? 1 : 0)
                        let sw = screenWidth() * 0.8
                        let sh = CGFloat(lines) * h + 96
                        let vc = MultiCardView(frame: CGRect(x: (screenWidth() - sw) / 2, y: (screenHeight() - sh) / 2, width: sw, height: sh))
                        vc.delegate = self
                        vc.loadImages(imgids)
                        self.view.addSubview(vc)
                    }
                }
            }
        } else {
            toast(msg: "上传图片失败.")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnLimitClicked(sender: Any) {
        let c = vc(name: "limit") as! LimitController
        navigationController?.pushViewController(c, animated: true)
    }
    
    @IBAction func btnPackClicked(sender: Any) {
        let c = vc(name: "pack") as! PackController
        navigationController?.pushViewController(c, animated: true)
    }
    
    @IBAction func btnDeckClicked(sender: Any) {
        let c = vc(name: "decklist") as! DeckListController
        navigationController?.pushViewController(c, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func btnKeywordClicked(sender: UIButton) {
        let c = vc(name: "cardlist") as! CardListController
        c.key = sender.currentTitle!
        navigationController?.pushViewController(c, animated: true)
    }
    
    @objc func btnHotCardClicked(sender: UIButton) {
        let hash = sender.accessibilityValue
        let name = sender.currentTitle
        let c = vc(name: "detail") as! CardDetailController
        c.cardname = name!
        c.hashid = hash!
        navigationController?.pushViewController(c, animated: true)
    }
    
    @objc func btnHotPackClicked(sender: UIButton) {
        let name = sender.currentTitle
        let url = sender.accessibilityValue
        let c = vc(name: "packdetail") as! PackDetailController
        c.name = name!
        c.url = url!
        navigationController?.pushViewController(c, animated: true)
    }
    
    @objc func btnHelpClicked(sender: UIButton) {
        let c = vc(name: "help") as! HelpController
        navigationController?.pushViewController(c, animated: true)
    }
    
    func onPopupImageClicked(imgid: String) {
        findImageHash(imgid)
    }
}

protocol ImagePopupDelegate {
    func onPopupImageClicked(imgid: String)
}

class MultiCardView: UIView {
    
    var delegate: ImagePopupDelegate?
    
    func loadImages(_ imgids: [String]) {
        // 左8右8，卡间距4，一行5张卡，总计32
        let w = (self.frame.width - 32) / 5
        let h = 23 * w / 16
        var t: CGFloat = 48
        var l: CGFloat = 8
        var count = 0
        for ii in imgids {
            let iv = UIImageView(frame: CGRect(x: l, y: t, width: w, height: h))
            iv.accessibilityValue = ii
            iv.contentMode = UIView.ContentMode.scaleAspectFit
            do {
                iv.image = try UIImage(data: Data(contentsOf: URL(string: "http://ocg.resource.m2v.cn/\(ii).jpg")!))
            } catch {
                
            }
            iv.isUserInteractionEnabled = true
            iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(sender:))))
            self.addSubview(iv)
            count += 1
            if (count == 5) {
                l = 8
                t += h + 4
            } else {
                l += w + 4
            }
        }
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        delegate?.onPopupImageClicked(imgid:sender.view!.accessibilityValue!)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout(base: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func layout(base: UIView) {
        base.layer.borderWidth = 1.0
        base.layer.borderColor = UIColor.lightGray.cgColor
        base.layer.cornerRadius = 5.0
        base.backgroundColor = darkColor
        
        let tvTitle = UILabel(frame: CGRect(x: 8, y: 4, width: base.frame.width - 16, height: 40))
        tvTitle.text = "找到多张卡片"
        tvTitle.textColor = UIColor.white
        base.addSubview(tvTitle)
        
        let btnClose = UIButton(type: UIButton.ButtonType.system)
        btnClose.frame = CGRect(x: base.frame.width - 68, y: base.frame.height - 48, width: 60, height: 40)
        btnClose.setTitle("Close", for: UIControl.State.normal)
        btnClose.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btnClose.addTarget(self, action: #selector(btnCloseClicked(_:)), for: UIControl.Event.touchDown)
        base.addSubview(btnClose)
    }
    
    @objc func btnCloseClicked(_ sender: UIButton) {
        self.removeFromSuperview()
    }
}
