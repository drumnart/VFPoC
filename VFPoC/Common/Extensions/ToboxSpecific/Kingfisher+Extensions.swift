//
//  Kingfisher+Extensions.swift
//  VFPoC
//
//  Created by Sergey Gorin on 12/03/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {
    
    public typealias CompletionClosure = (
        _ result: Kingfisher.Result<RetrieveImageResult, KingfisherError>,
        _ base: UIImageView?) -> Void
    
    @discardableResult
    func loadImage(withURLString urlString: String,
                  placeholder: UIImage? = UIImage.fromColor(.tbxLightBlueGrey),
                  options: KingfisherOptionsInfo? = [.downloadPriority(1), .transition(.fade(0.1))],
                  progressBlock: DownloadProgressBlock? = nil,
                  completion: CompletionClosure? = nil) -> DownloadTask? {
        return kf.setImage(
            with: URL(string: urlString),
            placeholder: placeholder,
            options: options,
            progressBlock: progressBlock,
            completionHandler: { [weak self] in
                completion?($0, self)
        })
    }
    
    func cancelDownloading() {
        kf.cancelDownloadTask()
    }
}
