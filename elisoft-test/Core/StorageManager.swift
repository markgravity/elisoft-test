//
//  StorageManager.swift
//  elisoft-test
//
//  Created by Mark G on 09/11/2020.
//

import UIKit

typealias StorageCompletion = ((_ image: UIImage)->Void)
class StorageManager: NSObject {
    static let shared = StorageManager()
    
    fileprivate var _session: URLSession!
    fileprivate var _sessionKey: Int = 0
    
    /// Downloading Images
    fileprivate var _downloadingImages = [Int:StorageCompletion]()
    
    /// Cached Image
    fileprivate var _cachedImages = [Int:UIImage]()
    
    override init() {
        super.init()
        _session = _makeSession()
    }
    
}

//MARK: - Public
extension StorageManager {
    
    func cached(at index: Int) -> UIImage? {
        _cachedImages[index]
    }
    
    func get(at index: Int, size: CGSize, completion: @escaping StorageCompletion) {
        
        
        let sessionKey = self._sessionKey
        
        // Set completion handler
        _downloadingImages[index] = completion
        
        // Download image
        let url = URL(string: "https://lorempixel.com/200/200/")!
        _session.dataTask(with: url) { data, response, error in
            
            var completion: StorageCompletion?
            if sessionKey == self._sessionKey {
                completion = self._downloadingImages.removeValue(forKey: index)
            }
            
            // Apply screen scale
            let scale = UIScreen.main.scale
            let targetSize = CGSize(
                width: size.width * scale,
                height: size.height * scale
            )
            
            // Process downloaded image data
            guard let data = data,
                  let image = UIImage(data: data)?.resize(targetSize: targetSize)
            else { return }
            
            
            // Cache the image
            self._cachedImages[index] = image
            
            // Callback on main thread
            DispatchQueue.main.async {
                completion?(image)
            }
            
        }.resume()
    }
    
    func clean() {
        _session.invalidateAndCancel()
        _session = _makeSession()
        _cachedImages = [:]
        _downloadingImages = [:]
    }
}

//MARK: - Private
fileprivate extension StorageManager {
    func _makeSession() -> URLSession {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        config.httpMaximumConnectionsPerHost = 10
        _sessionKey += 1
        return URLSession(configuration: config)
    }
}
