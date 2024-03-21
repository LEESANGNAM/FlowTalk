//
//  UIImageView+Extension.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/21/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with urlString: String, frameSize imageSize: CGSize, placeHolder: String, completion: ((UIImage?) -> Void)? = nil) {
        self.kf.indicatorType = .activity
        
        let imageURLString = APIKey.baseURL + "/v1" + urlString
        
        guard let url = URL(string: imageURLString) else {
            completion?(nil)
            return
        }
        
        let imageLoadRequest = AnyModifier { request in
            var requestBody = request
            requestBody.setValue(APIKey.key, forHTTPHeaderField: "SesacKey")
            requestBody.setValue(UserDefaultsManager.token, forHTTPHeaderField: "Authorization")
            return requestBody
        }
        let testSize = CGSize(width: imageSize.width * 3, height: imageSize.height * 3)
        let downSizeProcessor = DownsamplingImageProcessor(size: testSize) // 사이즈만큼 줄이기
        
        let resource = KF.ImageResource(downloadURL: url, cacheKey: imageURLString)
        self.kf.setImage(
            with: resource,
            options: [
                .processor(downSizeProcessor),
                .requestModifier(imageLoadRequest),
            ]) { result in
                switch result {
                case .success(let data):
                    self.image = data.image
                    completion?(data.image)
                case .failure(_):
                    self.image = UIImage(named: placeHolder)
                    completion?(nil)
                }
            }
    }
                
}

