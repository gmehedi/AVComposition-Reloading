//
//  ThumGenerator.swift
//  Video Test
//
//  Created by Mehedi Hasan on 2/3/22.
//

import Foundation
import UIKit
import AVKit
import AVFoundation


class ThumGenerator {
    
    var thumbnailFrameSize: CGSize = CGSize(width: 640,height: 480)
    let preferredTimescale:Int32 = 100
    var timeTolerance = CMTimeMakeWithSeconds(10 , preferredTimescale: 100)

    var maxWidth:CGFloat = 0
    var minWidth:CGFloat = 0
    
    
    
    
    func requestImageGeneration(complationHandler: @escaping( ([UIImage]) -> Void ), asset: AVURLAsset, totalFrame: Int) {
        
        
        let preferredTimescale: Int32 = 100
        
        let duration: CGFloat = asset.duration.seconds
        
        let diff = duration / Double(totalFrame)
        var now: Float64 = diff
        
        var timesArray = [NSValue]()
        for index in 0 ..< totalFrame {
            timesArray += [NSValue(time:CMTimeMakeWithSeconds(Float64(now) , preferredTimescale:preferredTimescale))]
            now += diff
        }
        
        var images = [UIImage]()
        
        let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let maxsize = CGSize(width: thumbnailFrameSize.width * 1.5,height: thumbnailFrameSize.height * 1.5)
        assetImgGenerate.maximumSize = maxsize
        assetImgGenerate.requestedTimeToleranceAfter = timeTolerance
        assetImgGenerate.requestedTimeToleranceBefore = timeTolerance
        
        assetImgGenerate.generateCGImagesAsynchronously(forTimes: timesArray) { CMtime, cgImage, cMTime, result,  error in
            
            if let image = cgImage {
                let uiImage = UIImage(cgImage: image)
                images.append(uiImage)
                
                print("Counttt   ", images.count)
                complationHandler(images)
            }
        }
        
    }
  
}
