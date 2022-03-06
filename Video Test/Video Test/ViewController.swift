//
//  ViewController.swift
//  Video Test
//
//  Created by Mehedi Hasan on 13/2/22.
//

import UIKit
import AVFAudio
import AVKit
import MetalPetal

class ViewController: UIViewController {

    let context = try? MTIContext(device: MTLCreateSystemDefaultDevice()!)
    
    @IBOutlet weak var videoView: UIView!
    var layer: AVPlayerLayer?
    @IBOutlet weak var videoView2: UIView!
    let conyext = CIContext()
    @IBOutlet weak var imageView2: UIImageView!
    
    @IBOutlet weak var imageView: UIImageView!
    var player: AVPlayer?
    var commonCom: AVMutableVideoComposition?
    var switchNow = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let url = Bundle.main.url(forResource: "v", withExtension: "MP4")
        let asset = AVURLAsset(url: url!)
     
        
        ThumGenerator().requestImageGeneration(complationHandler: {_ in
            
        }, asset: asset, totalFrame: 1000)
        self.playVideo(asset: asset)
        //self.playVideo2(asset: asset)
    }
    
    @IBAction func tqppedOnButton(_ sender: Any) {
        
        if switchNow {
            switchNow = false
            self.updateComposition()
        }else {
            switchNow = true
            self.updateComposition1()
        }
        
    }
    
}

extension ViewController {
    
    func playVideo(asset: AVAsset) {
        
        DispatchQueue.global(qos: .userInitiated).async {
        
        let url = Bundle.main.url(forResource: "v", withExtension: "MP4")
            
        let com2 = self.getCom(videoUrl: url!, audioUrl: url!)
        
            self.commonCom = AVMutableVideoComposition(asset: asset) { [weak self] request in
            
            guard let self = self else {
                request.finish(with: Error.self as! Error)
                return
            }

            let image = request.sourceImage
            var now = image.copy() as! CIImage
            
          //  let trans = CGAffineTransform(scaleX: 0.5, y: 0.5)
            
            now = now.transformed(by: CGAffineTransform(scaleX: 0.5, y: 0.5))
            print("Size 11  ", image.extent.size)
            
        
            
//            let filter = CIFilter(name: "CISourceOverCompositing")
//            filter?.setValue(image, forKey: kCIInputBackgroundImageKey)
//            filter?.setValue(now, forKey: kCIInputImageKey)
//
          
            request.finish(with: image, context: self.conyext)
            
        }
            
            self.commonCom?.renderSize = asset.screenSize ?? .zero
       
            DispatchQueue.main.async {
                self.layer?.videoGravity = .resizeAspect
              
                let com3 = com2.copy() as! AVComposition
                
                let item = AVPlayerItem(asset: com3)
                item.videoComposition = self.commonCom!
                self.player = AVPlayer(playerItem: item)
                
                self.layer = AVPlayerLayer(player: self.player)
                self.layer?.frame = self.videoView?.bounds ?? .zero
                self.videoView.layer.addSublayer(self.layer!)
                self.player?.play()
            }
        
        }
        
       
        
    }
    
    func updateComposition() {
        
        let url = Bundle.main.url(forResource: "v2", withExtension: "MP4")
        
        let asset = AVURLAsset(url: url!)
        self.commonCom?.renderSize = asset.screenSize ?? .zero
        
        let com2 = self.getCom(videoUrl: url!, audioUrl: url!)
        let com3 = com2.copy() as! AVComposition
        let item = AVPlayerItem(asset: com3)
        item.videoComposition = commonCom!
        self.player?.replaceCurrentItem(with: item)
        self.player?.play()
        
    }
    
    func updateComposition1() {
        
        let url = Bundle.main.url(forResource: "v", withExtension: "MP4")
        
        let asset = AVURLAsset(url: url!)
        self.commonCom?.renderSize = asset.screenSize ?? .zero
        
        let com2 = self.getCom(videoUrl: url!, audioUrl: url!)
        let com3 = com2.copy() as! AVComposition
        let item = AVPlayerItem(asset: com3)
        item.videoComposition = commonCom!
        self.player?.replaceCurrentItem(with: item)
        self.player?.play()
        
    }
    
    
    
    func getCom(videoUrl: URL, audioUrl: URL) -> AVMutableComposition {
        let mixComposition : AVMutableComposition = AVMutableComposition()
            var mutableCompositionVideoTrack : [AVMutableCompositionTrack] = []
            var mutableCompositionAudioTrack : [AVMutableCompositionTrack] = []
            let totalVideoCompositionInstruction : AVMutableVideoCompositionInstruction = AVMutableVideoCompositionInstruction()


            //start merge

        let aVideoAsset : AVAsset = AVAsset(url: videoUrl)
        let aAudioAsset : AVAsset = AVAsset(url: audioUrl)

        mutableCompositionVideoTrack.append(mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)! )
        mutableCompositionAudioTrack.append( mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)!)

        let aVideoAssetTrack : AVAssetTrack = aVideoAsset.tracks(withMediaType: AVMediaType.video)[0]
        let aAudioAssetTrack : AVAssetTrack = aAudioAsset.tracks(withMediaType: AVMediaType.audio)[0]



            do{
                try mutableCompositionVideoTrack[0].insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: aVideoAssetTrack.timeRange.duration), of: aVideoAssetTrack, at: CMTime.zero)

                //In my case my audio file is longer then video file so i took videoAsset duration
                //instead of audioAsset duration

                try mutableCompositionAudioTrack[0].insertTimeRange(CMTimeRangeMake(start: .zero, duration: aVideoAssetTrack.timeRange.duration), of: aAudioAssetTrack, at: CMTime.zero)

                //Use this instead above line if your audiofile and video file's playing durations are same

                //            try mutableCompositionAudioTrack[0].insertTimeRange(CMTimeRangeMake(kCMTimeZero, aVideoAssetTrack.timeRange.duration), ofTrack: aAudioAssetTrack, atTime: kCMTimeZero)

            }catch{

            }
        
        return mixComposition
    }
    
    
    
    func playVideo2(asset: AVAsset) {
        
        let com = AVMutableVideoComposition(asset: asset) { [weak self] request in
            
            guard let self = self else {
                request.finish(with: Error.self as! Error)
                return
            }

            let image = request.sourceImage
            var now = image.copy() as! CIImage
            
          //  let trans = CGAffineTransform(scaleX: 0.5, y: 0.5)
            
            now = now.transformed(by: CGAffineTransform(scaleX: 0.5, y: 0.5))
            print("Size  ", image.extent.size)
            
            let filter = CIFilter(name: "CISourceOverCompositing")
            filter?.setValue(image, forKey: kCIInputBackgroundImageKey)
            filter?.setValue(now, forKey: kCIInputImageKey)
            
          
            if var img = filter?.outputImage {
                img = img.transformed(by: CGAffineTransform(scaleX: 0.3, y: 0.3))
                img = img.transformed(by: CGAffineTransform(translationX: 10, y: 10))
                let mti = MTIImage(ciImage: img)
                let tci = self.MTITOCI(outputImage: mti)
                DispatchQueue.main.async {
                   self.imageView2.image = UIImage(ciImage: tci!)
                }
                request.finish(with: img, context: self.conyext)
            }else {
                request.finish(with: request.sourceImage, context: self.conyext)
            }
            
        }
    
        com.renderSize = CGSize(width: 1000, height: 1000)
       
        
        layer?.videoGravity = .resizeAspect
      
        
        let item = AVPlayerItem(asset: asset)
        item.videoComposition = com
        player = AVPlayer(playerItem: item)
        
        layer = AVPlayerLayer(player: player)
        layer?.frame = videoView?.bounds ?? .zero
        self.videoView.layer.addSublayer(layer!)
        player?.play()
    }
    
   
    
    func MTITOCI(outputImage: MTIImage) -> CIImage? {
        
        do {
            
            var image3: CIImage? = try context?.makeCIImage(from: outputImage)
            
            //context.makeCIImage(from: image)
            return image3
            
            //context.makeCGImage(from: image)
        } catch {
            print(error)
        }
        return nil
    }
    
}

extension AVAsset {
    var screenSize: CGSize? {
        if let track = tracks(withMediaType: .video).first {
            let size = __CGSizeApplyAffineTransform(track.naturalSize, track.preferredTransform)
            return CGSize(width: fabs(size.width), height: fabs(size.height))
        }
        return nil
    }
}
