//
//  ViewController.swift
//  CustomCameraViewApp
//
//  Created by Daniel Seitenfus on 22/06/21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var label: UILabel!
    var session: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCameraAccess()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
       
    }
    
    private func checkCameraAccess(){
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            //self.initConfigurations()
            //self.validarToken()
            DispatchQueue.main.async {
                self.initConfigurations()
            }
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                if granted == true {
                    //self.initConfigurations()
                    DispatchQueue.main.async {
                        self.initConfigurations()
                    }
                } else {
                    print("erro")
                }
            })
        }
    }
    
    func initConfigurations(){
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSession.Preset.photo
        let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera!)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }
        if error == nil && session!.canAddInput(input) {
            session!.addInput(input)
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput?.outputSettings = [AVVideoCodecKey:  AVVideoCodecJPEG]
            if session!.canAddOutput(stillImageOutput!) {
                session!.addOutput(stillImageOutput!)
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
                videoPreviewLayer!.videoGravity =    AVLayerVideoGravity.resizeAspect
                videoPreviewLayer!.connection?.videoOrientation =   AVCaptureVideoOrientation.portrait
                previewView.layer.addSublayer(videoPreviewLayer!)
                videoPreviewLayer!.frame = previewView.bounds
                session!.startRunning()
            }
        }
    }
    
    
}

