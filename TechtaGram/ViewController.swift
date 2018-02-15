//
//  ViewController.swift
//  TechtaGram
//
//  Created by arisa isshiki on 2018/02/12.
//  Copyright © 2018年 alisa. All rights reserved.
//

import UIKit
import Accounts

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var cameraImageView: UIImageView!
    
    //画像加工するための元となる画像
    var originalImage: UIImage!
    //画像加工するフィルターの宣言
    var filter: CIFilter!
    
    
    //スタンプ画像の名前が入った配列
    var imageNameArray: [String] = ["neko.png", "kira.png", "kappa4.png"]
    
    //選択しているスタンプ画像の番号
    var imageIndex: Int = 0
    
    //背景画像を表示させるImageView
    //@IBOutlet var haikeiImageView: UIImageView!
    
    //スタンプ画像が入るImageView
    var ImageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //撮影する時のメゾット
    @IBAction func useCamera(){
        //カメラが使えるかの確認
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            //カメラ起動
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
        }else{
            //カメラが使えないときはエラーがコンソールに
            print("error")
        }
    }
    //カメラ、カメラロールを使った時に選択した画像をアプリ内に表示する為のメゾット
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        cameraImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        originalImage = cameraImageView.image
        
        dismiss(animated: true, completion: nil)
    }
    
    
    //表示している画像にフィルター加工
    @IBAction func applyFilter(){
        
        let filterImage: CIImage = CIImage(image: originalImage)!
        
        //フィルターの設定
        filter = CIFilter(name: "CIColorControls")!
        filter.setValue(filterImage, forKey: kCIInputImageKey)
        //彩度の調整
        filter.setValue(1.0, forKey: "inputSaturation")
        //明度の調整
        filter.setValue(0.5, forKey: "inputBrightness")
        //コントラストの調整
        filter.setValue(2.5, forKey: "inputContrast")
        
        let ctx = CIContext(options: nil)
        let cgImage = ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        cameraImageView.image = UIImage(cgImage: cgImage!)
        
    }
    //編集した画像保存
    @IBAction func save(){
        
        UIImageWriteToSavedPhotosAlbum(cameraImageView.image!, nil, nil, nil)
        
    }
    //カメラロールにある画像を読み込む
    @IBAction func openAlbum(){
        
        //カメラロールを使えるか
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //カメラロールの画像を選択して画像を表示
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //タッチされた位置を取得
        let touch:UITouch = touches.first!
        let location: CGPoint = touch.location(in: self.view)
        
        //もし,imageIndexが0でない　（押すスタンプが選ばれていない）とき
        if imageIndex != 0 {
            //スタンプサイズを40pxの正方形に指定
            ImageView = UIImageView(frame: CGRect(x: 0, y:0, width: 70, height: 70))
            
            //押されたスタンプの画像を指定
            let image: UIImage = UIImage(named: imageNameArray[imageIndex - 1])!
            ImageView.image = image
            
            //タッチされた位置に画像を置く
            ImageView.center = CGPoint(x: location.x ,y : location.y)
            
            //画像を表示する
            self.view.addSubview(ImageView)
            
        }
    }
    
    @IBAction func selectedFirst() {
        imageIndex = 1
    }
    
    @IBAction func selectedSecond() {
        imageIndex = 2
    }
    
    @IBAction func selectedThird() {
        imageIndex = 3
    }
    
    
    
    //編集した画像をシェアする
    @IBAction func share(){
        
        //投稿する時、一緒に載せるコメント
        let shareText = "写真加工できた"
        //投稿する画像の選択
        let shareImage = cameraImageView.image!
        //投稿するコメントと画像の準備
        let activityItems: [Any] = [shareText, shareImage]
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        let excludeActivityTypes = [UIActivityType.postToVimeo, .saveToCameraRoll, .print]
        activityViewController.excludedActivityTypes = excludeActivityTypes
        present(activityViewController, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

