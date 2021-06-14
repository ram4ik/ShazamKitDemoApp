//
//  ViewController.swift
//  ShazamKitDemoApp
//
//  Created by ramil on 14.06.2021.
//

import UIKit
import ShazamKit

class ViewController: UIViewController, SHSessionDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        recognizeSong()
    }

    private func recognizeSong() {
        let session = SHSession()
        session.delegate = self
        do {
            guard let url = Bundle.main.url(forResource: "song", withExtension: "mp3") else { return }
            let file = try AVAudioFile(forReading: url)
            guard let buffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity: AVAudioFrameCount(file.length / 30)) else { return }
            try file.read(into: buffer)
            let generator = SHSignatureGenerator()
            try generator.append(buffer, at: nil)
            let signature = generator.signature()
            session.match(signature)
        } catch {
            print(error)
        }
    }
    
    func session(_ session: SHSession, didFind match: SHMatch) {
        let items = match.mediaItems
        items.forEach { item in
            print(item.title ?? "n/a")
            print(item.artist ?? "n/a")
            print(item.artworkURL?.absoluteURL ?? "n/a")
        }
    }
    
    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        if let error = error {
            print(error)
        }
    }
}

