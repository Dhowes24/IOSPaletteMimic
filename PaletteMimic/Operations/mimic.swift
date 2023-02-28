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

func mimicPalette(firstPalette: [UInt32], secondPalette: [UInt32], secondImgArr: inout [Pixel], secondImage: UIImage){
    
    let pixelCount = secondImgArr.count
    var paletteProgress = 0
    
    for i in 0...pixelCount-1 {
        if i > ((paletteProgress + 1)/16 * (pixelCount)) {
            paletteProgress += 1
            print("Recolor: \(round((Double(paletteProgress)/15) * 1000) / 10)%")
        }
        
        let pixelRed = Int(secondImgArr[i].color & 0x000000ff)
        let paletteRed = Int(secondPalette[paletteProgress] & 0x000000ff)
        let redChange = (pixelRed - paletteRed)
        
        let pixelGreen = Int((secondImgArr[i].color & 0x0000ff00) >> 8)
        let paletteGreen = Int((secondPalette[paletteProgress] & 0x0000ff00) >> 8)
        let greenChange = (pixelGreen - paletteGreen)
        
        let pixelBlue = Int((secondImgArr[i].color & 0x00ff0000) >> 16)
        let paletteBlue = Int((secondPalette[paletteProgress] & 0x00ff0000) >> 16)
        let blueChange = (pixelBlue - paletteBlue)
        
        let newRed = abs(Int(firstPalette[paletteProgress] & 0x000000ff) + redChange)
        let newGreen = abs(Int((firstPalette[paletteProgress] & 0x0000ff00) >> 8) + Int(greenChange))
        let newBlue = abs(Int((firstPalette[paletteProgress] & 0x00ff0000) >> 16) + Int(blueChange))
        
        let newColor =
        UInt32(newRed) |
        UInt32((newGreen) << 8) |
        UInt32((newBlue) << 16) |
        (UInt32(255) << 24)
        
        secondImgArr[i].color = newColor
    }
}


func createPhoto(pixels:[Pixel], image: UIImage, firstPalette: [UInt32], secondPalette: [UInt32]) -> UIImage {
    
    var mutablePixels = pixels
    
    mimicPalette(firstPalette: firstPalette, secondPalette: secondPalette, secondImgArr: &mutablePixels, secondImage: image)
    
    var newData: [UInt32] = []
    mutablePixels.sort {($0.place) < ($1.place)}
    
    for pixel in mutablePixels {
        newData.append(pixel.color)
    }
    
    let cgImg = newData.withUnsafeMutableBytes { (ptr) -> CGImage in
        let ctx = CGContext(
            data: ptr.baseAddress,
            width: Int(image.size.width),
            height: Int(image.size.height),
            bitsPerComponent: 8,
            bytesPerRow: 4*Int(image.size.width),
            space: CGColorSpace(name: CGColorSpace.sRGB)!,
            bitmapInfo: CGBitmapInfo.byteOrder32Big.rawValue +
            CGImageAlphaInfo.premultipliedLast.rawValue
        )!
        return ctx.makeImage()!
    }
    
    
    
    return UIImage(cgImage: cgImg)
}
