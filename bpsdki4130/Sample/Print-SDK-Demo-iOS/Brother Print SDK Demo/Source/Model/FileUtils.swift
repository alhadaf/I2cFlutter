//
//  FileUtils.swift
//  Brother Print SDK Demo
//
//  Created by mac99 on 2023/7/12.
//

import Foundation

class FileUtils {
    static func copyFileToTemp(urls: [URL]) -> [URL] {
        guard let cachePath = try? FileManager.default.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("tempFileDir", isDirectory: true) else { return [] }
        try? createIfNeeded(path: cachePath)
        var urlList: [URL] = []
        urls.forEach({ url in
            let path = cachePath.appendingPathComponent(url.lastPathComponent)
            guard url.absoluteURL != path.absoluteURL else {
                urlList.append(url)
                return
            }

            try? FileManager.default.copyItem(at: url, to: path)
            urlList.append(path)
        })
        return urlList
    }
    
    static func readLocalFiles(urls: [URL]) -> [Data] {
        var dataArray: [Data] = []
        for url in urls {
            do {
                let data = try Data(contentsOf: url)
                dataArray.append(data)
            } catch {
                print("Failed to read file at \(url.path): \(error)")
            }
        }
        return dataArray
    }

    static func clearTempDir() {
        guard let cachePath = try? FileManager.default.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("tempFileDir", isDirectory: true) else { return }
        try? FileManager.default.removeItem(at: cachePath)
    }

    private static func createIfNeeded(path: URL) throws {
        let manager = FileManager.default
        guard !manager.fileExists(atPath: path.path) else { return }
        guard path.hasDirectoryPath else { return }
        try manager.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
    }
}
