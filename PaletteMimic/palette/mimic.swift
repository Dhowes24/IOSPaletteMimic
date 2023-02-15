//
//  main.swift
//  PaletteMimic
//
//  Created by Derek Howes on 12/23/22.
//

import Foundation
import UIKit
import CoreGraphics
import SwiftUI

func mimicPalette(firstPalette: [[Int]], secondPalette: [[Int]], secondImgArr: [[Int]], secondImage: UIImage){
//    func mimicPalette(firstPalette: [[Int]], secondPalette: [[Int]], secondImgArr: [[Int]], secondImage: UIImage) -> UIImage{

    var progressCounter = 0
    let pixelCount = secondImgArr.count
    var newImg = Array<UInt32>(repeating: 00000000, count: Int(pixelCount))
    var uInt32Temp:UInt32 = 0
    
    for i in 0..<firstPalette.count {
        for _ in 0...Int(pixelCount/16) {
            let redChange = (secondImgArr[progressCounter][0] - secondPalette[i][0])>255 ?
            255 : secondImgArr[progressCounter][0] - secondPalette[i][0]
            let greenChange = (secondImgArr[progressCounter][1] - secondPalette[i][1])>255 ?
            255 : secondImgArr[progressCounter][1] - secondPalette[i][1]
            let blueChange = (secondImgArr[progressCounter][2] - secondPalette[i][2])>255 ?
            255 : secondImgArr[progressCounter][2] - secondPalette[i][2]

            uInt32Temp =
            UInt32(abs(firstPalette[i][0] + redChange)) |
            UInt32(abs(firstPalette[i][1] + greenChange)) << 8 |
            UInt32(abs(firstPalette[i][2] + blueChange)) << 16 |
            UInt32(255) << 24

            newImg.insert(uInt32Temp, at: secondImgArr[progressCounter][4])

            progressCounter += 1
        }
    }
//    return createPhoto(pixels: newImg, width: Int(secondImage.size.width), height: Int(secondImage.size.height))
}


//func createPhoto(pixels:[[Int]], width: Int, height: Int) -> UIImage {
    func createPhoto(pixels:[UInt32], width: Int, height: Int) -> UIImage {


//    MIMC PALETTE INTO UINT32 FORMAT()
    print(pixels[0])
    
    var data = pixels
    
     let cgImg = data.withUnsafeMutableBytes { (ptr) -> CGImage in
         let ctx = CGContext(
             data: ptr.baseAddress,
             width: width,
             height: height,
             bitsPerComponent: 8,
             bytesPerRow: 4*width,
             space: CGColorSpace(name: CGColorSpace.sRGB)!,
             bitmapInfo: CGBitmapInfo.byteOrder32Big.rawValue +
                 CGImageAlphaInfo.premultipliedLast.rawValue
             )!
         return ctx.makeImage()!
     }
    
    
    
    return UIImage(cgImage: cgImg)
}
