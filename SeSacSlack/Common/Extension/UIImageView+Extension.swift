//
//  UIImageView+Extension.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/21/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with urlString: String,frameSize imageSize: CGSize,placeHolder: String) {
            self.kf.indicatorType = .activity
            ImageCache.default.retrieveImage(forKey: urlString, options: nil) { result in
                switch result {
                case .success(let value):
                    if let image = value.image {
                        //캐시가 존재하는 경우
                        print("캐시이미지 들어감")
                        self.image = image
                    } else {
                        //캐시가 존재하지 않는 경우
                        guard let url = URL(string: urlString) else { return }
                        
                        let imageLoadRequest = AnyModifier { request in
                            var requestBody = request
                            requestBody.setValue(APIKey.key, forHTTPHeaderField: "SesacKey")
                            requestBody.setValue(UserDefaultsManager.token, forHTTPHeaderField: "Authorization")
                            return requestBody
                        }
                        let testSize = CGSize(width: imageSize.width * 3, height: imageSize.height * 3)
                        let dowunSizeProcessor = DownsamplingImageProcessor(size: testSize) //사이즈만큼 줄이기
                        
                        let resource = KF.ImageResource(downloadURL: url, cacheKey: urlString)
                        self.kf.setImage(
                            with: resource,
                            options: [
                                .processor(dowunSizeProcessor),
                                .requestModifier(imageLoadRequest),
                            ]) { result in
                                switch result {
                                case .success(let data):
                                    self.image = data.image
                                case .failure(_):
                                    self.image = UIImage(named: placeHolder)
                                }
                            }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
}
