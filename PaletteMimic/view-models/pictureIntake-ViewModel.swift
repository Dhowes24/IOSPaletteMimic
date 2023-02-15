//
//  picture-intake-view-model.swift
//  PaletteMimic
//
//  Created by Derek Howes on 12/22/22.
//

import Foundation
import SwiftUI

extension pictureIntakeScreen {
    @MainActor class pictureIntake_ViewModel: ObservableObject {
        
        var firstImage: UIImage?
        var secondImage: UIImage?
        
        @Published var showIntro = false
        @Published var showFinal = false
        
        var firstPalette: [UInt32] = []
        @Published var firstColorifiedPalette: [Color] = Array(repeating: Color.white, count: 16)
        @Published var firstSortedArr: [UInt32] = []
        @Published var firstProgress = 0.0
        
        @Published var secondPalette: [UInt32] = []
        @Published var secondColorifiedPalette: [Color] = Array(repeating: Color.white, count: 16)
        @Published var secondSortedArr: [UInt32] = []
        @Published var secondProgress = 0.0
                
        @MainActor func findRed(_ pixel: UInt32) -> UInt32 {
            return (pixel & 0x000000ff)
        }
        
        @MainActor func findGreen(_ pixel: UInt32) -> UInt32 {
            return (pixel & 0x0000ff00) >> 8
        }
        
        @MainActor func findBlue(_ pixel: UInt32) -> UInt32 {
            return (pixel & 0x00ff0000) >> 16
        }
        
        func find_UInt32_pixel_range(data: [UInt32]) -> @MainActor (UInt32) -> UInt32 {
            
            var minMaxArr = [[UInt32]](repeating: [255,0], count: 3)
            for y in 0 ..< data.count-1 {
                
                //Red
                let red = findRed(data[y])
                if red < minMaxArr[0][0] {
                    minMaxArr[0][0] = red }
                else if red >= minMaxArr[0][1] {
                    minMaxArr[0][1] = red }
                
                //Blue
                let blue = findBlue(data[y])
                if blue < minMaxArr[1][0] {
                    minMaxArr[1][0] = blue }
                else if blue > minMaxArr[1][1] {
                    minMaxArr[1][1] = blue }
                
                //Green
                let green = findGreen(data[y])
                if green < minMaxArr[2][0] {
                    minMaxArr[2][0] = green }
                else if green >= minMaxArr[2][1] {
                    minMaxArr[2][1] = green }
            }
            
            var ranges = [UInt32]()
            for i in 0...2 {
                ranges.append(minMaxArr[i][1] - minMaxArr[i][0])
            }
            
            var colorRange:@MainActor (UInt32) -> UInt32
            switch ranges.firstIndex(of: max(ranges[0], ranges[1],ranges[2])){
            case 0:
                colorRange = findRed
            case 1:
                colorRange = findGreen
            case 2:
                colorRange = findBlue
            case .none:
                colorRange = findBlue
            case .some(_):
                colorRange = findBlue
            }
            
            return(colorRange)
        }
        
        func find_UInt32_pixel_avg(img_arr: [UInt32], colorRange: @MainActor (UInt32) -> UInt32) -> UInt32 {
            
            var avg:UInt32 = 0
            for i in 0..<img_arr.count {
                avg += colorRange(img_arr[i])
            }
            
            return avg / UInt32(img_arr.count)
        }
        
        func get_pixel_data(img: UIImage) -> [UInt32]? {
            
            let size = img.size
            let dataSize = Int(size.width) * Int(size.height)
            var pixelData = [UInt32](repeating: 0, count: dataSize)
            
            let context = CGContext(data: &pixelData,
                                    width: Int(size.width),
                                    height: Int(size.height),
                                    bitsPerComponent: 8,
                                    bytesPerRow: 4 * Int(size.width),
                                    space: CGColorSpace(name: CGColorSpace.sRGB)!,
                                    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
            guard let cgImage = img.cgImage else { return nil }
            context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            
            print("get_pixel_data Complete")
            
            return pixelData
        }
        
        func UInt32_split_into_buckets(img: UIImage, img_arr: [UInt32], depth: Int, photoNum: Int) async {
            
            if img_arr.count == 0 {
                return
            }
            
            if depth == 0 {
                photoNum == 1 ? self.firstSortedArr.append(contentsOf: img_arr) : self.secondSortedArr.append(contentsOf: img_arr)
                UInt32_median_cut_quantize(img_arr: img_arr, photoNum: photoNum)
                return
            }
            
            let color_range = find_UInt32_pixel_range(data: img_arr)
            var sorted_arr = img_arr
            sorted_arr.sort {(color_range($0) as UInt32) < (color_range($1) as UInt32)}
            let median_index = (sorted_arr.count + 1)/2
            
            print("split \(depth) complete")
            await UInt32_split_into_buckets(img: img, img_arr: Array(sorted_arr[0...median_index]), depth: depth-1, photoNum: photoNum)
            await UInt32_split_into_buckets(img: img, img_arr: Array(sorted_arr[median_index...]), depth: depth-1, photoNum: photoNum)
            
        }
        
        func UInt32_median_cut_quantize(img_arr: [UInt32], photoNum: Int) {
            
            let r_avg = find_UInt32_pixel_avg(img_arr: img_arr, colorRange: findRed)
            let b_avg = find_UInt32_pixel_avg(img_arr: img_arr, colorRange: findGreen)
            let g_avg = find_UInt32_pixel_avg(img_arr: img_arr, colorRange: findBlue)
            
            let full_color:UInt32 = UInt32(r_avg) + UInt32(b_avg) << 8 + UInt32(g_avg) << 16 + UInt32(0) << 24
            
            photoNum == 1 ? self.firstPalette.append(full_color) : self.secondPalette.append(full_color)
            
            photoNum == 1 ? self.firstColorifiedPalette.removeFirst() : self.secondColorifiedPalette.removeFirst()
            
            let color = convert_to_color_single(palette: full_color)
            photoNum == 1 ? self.firstColorifiedPalette.append(color) : self.secondColorifiedPalette.append(color)
        }
        
        func convert_to_color(palette: [UInt32]) -> [Color] {
            var colorPalette: [Color] = []
            palette.forEach {i in
                colorPalette.append(
                    Color(
                        red: Double(Int(i & 0x000000ff)) / 255.0,
                        green: Double(Int(i & 0x0000ff00) >> 8) / 255.0,
                        blue: Double(Int(i & 0x00ff0000) >> 16) / 255.0
                    )
                )
            }
            return colorPalette
        }
        
        func convert_to_color_single(palette: UInt32) -> Color {
            
            return Color(
                red: Double(Int(palette & 0x000000ff)) / 255.0,
                green: Double(Int(palette & 0x0000ff00) >> 8) / 255.0,
                blue: Double(Int(palette & 0x00ff0000) >> 16) / 255.0
            )
        }
        
        func UInt32_call() async {
            
            
//            Testing Update of View on change when CPU isn't Clocked
//            -----------------------------------------------------------------------------------------------------------------------
            //            let array: [UInt32] = [395786, 922391, 1186846, 1516324, 1780009, 2043951, 2242355, 2442551, 3555401, 4477011, 5528926, 7368052, 10191759, 12360615, 13873851, 15059921]
            //
            for i in 0...10 {
                            try? await Task.sleep(nanoseconds: 100000000)
                                print(firstProgress)
                firstProgress += 0.1
//                                self.firstColorifiedPalette.removeFirst()
//                                let newColor = self.convert_to_color_single(palette: color)
//                                self.firstColorifiedPalette.append(newColor)
                        }
//            -----------------------------------------------------------------------------------------------------------------------
            
            
            
//            Task {
//                let firstImageData = get_pixel_data(img: firstImage!)
//                print("beginning 1st Image")
//                
//                await UInt32_split_into_buckets(img: firstImage!, img_arr: firstImageData!, depth: 4, photoNum: 1)
//            }
            
            //            Task{
            //                let secondImageData = get_pixel_data(img: secondImage!)
            //                print("beginning 2nd Image")
            //                await UInt32_split_into_buckets(img: secondImage!, img_arr: secondImageData!, depth: 4, photoNum: 2)
            //            }
            
        }
    }
}