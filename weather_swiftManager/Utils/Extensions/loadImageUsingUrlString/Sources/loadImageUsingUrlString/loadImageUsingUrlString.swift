//
//  loadImageUsingUrlString.swift
//  weather
//
//  Created by Kirill Titov on 13.11.2020.
//

import UIKit
import Alamofire

let imageCache = NSCache<NSString, AnyObject>()
public extension UIImageView {

    func loadImageUsingUrlString(urlString: String) {
		image = nil

		if urlString.isEmpty { return }
		
		// cache version of image
		if let imageFromCache = imageCache.object(forKey: urlString as NSString ) as? UIImage {
			self.image = imageFromCache
			return
		}

		// image into cache
		AF.download(urlString).responseData { response in
			switch response.result {
			case .success:
				guard let imageToCach = UIImage(data: response.value!) else { return }
				DispatchQueue.main.async {
					imageCache.setObject(imageToCach, forKey: urlString as NSString)
					self.image = imageToCach
				}
			case let .failure(error):
				print(error)
			}
		}.resume()
	}
}

