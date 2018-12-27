//
//  PhotoCameraVC.swift
//  Vriends
//
//  Created by Tanner Luke on 11/5/18.
//  Copyright © 2018 Tanner Luke. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoCameraVC: UIViewController {

    @IBOutlet weak var closeOutButton: UIButton!
    @IBOutlet weak var switchCamsButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    
    var passedPhotoArray = [UIImage]()
    
    //Camera Variables
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var image: UIImage?
    var currentCameraIsBack = true
    var currentFlashMode: Int = -1
    var flash: CurrentFlashMode = .off
    
    enum CurrentFlashMode {
        case off
        case on
        case auto
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        print(passedPhotoArray)
        setupCamera()
    }
    
    
    func setupCamera() {
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
    }
    

    func getSettings(camera: AVCaptureDevice, flashMode: CurrentFlashMode) -> AVCapturePhotoSettings {
        
        let settings = AVCapturePhotoSettings()
        if camera.hasFlash {
            switch flashMode {
                case .auto: settings.flashMode = .auto
                case .on: settings.flashMode = .on
                default: settings.flashMode = .off
            }
        }
        return settings
    }
    
    @IBAction func pinchToZoom(_ sender: UIPinchGestureRecognizer) {
        guard let device = currentCamera else { return }
        if sender.state == .changed {
            let maxZoomFactor = device.activeFormat.videoMaxZoomFactor
            let pinchVelocityDividerFactor: CGFloat = 5.0
            do {
                try device.lockForConfiguration()
                defer { device.unlockForConfiguration() }
                let desiredZoomFactor = device.videoZoomFactor + atan2(sender.velocity, pinchVelocityDividerFactor)
                device.videoZoomFactor = max(1.0, min(desiredZoomFactor, maxZoomFactor))
            } catch {
                print(error)
            }
        }
    }
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.high
    }
    
    func setupDevice() {
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        currentCamera = getCamera()
    }
    
    
    
    
    
    func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }
    
    func endInputOutput() {
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                captureSession.removeInput(input)
            }
        }
        let outputs = captureSession.outputs as [AVCaptureOutput]
        for output in outputs {
            captureSession.removeOutput(output)
        }
        
    }
    
    func setupPreviewLayer() {
        
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        cameraPreviewLayer?.backgroundColor = UIColor.black.cgColor
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
    }
    
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
    @IBAction func takePicture(_ sender: Any) {
        let settings = getSettings(camera: currentCamera!, flashMode: flash)
        photoOutput?.capturePhoto(with: settings, delegate: self)
        
    }
    
    @IBAction func closeOutClick(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switchCamsClick(_ sender: Any) {
        if currentCamera == backCamera {
            currentCamera = frontCamera
        } else if currentCamera == frontCamera {
            currentCamera = backCamera
        }
        endInputOutput()
        setupInputOutput()
    }
    
    func getCamera() -> AVCaptureDevice {
        if currentCamera == nil {
            return backCamera!
        } else {
            return currentCamera!
        }
    }
    
    @IBAction func flashClick(_ sender: Any) {
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPicPreview" {
            let previewVC = segue.destination as! PreviewPhotoVC
            previewVC.passedPhotoArray = self.passedPhotoArray
            if currentCamera == backCamera {
                previewVC.image = image
            } else if currentCamera == frontCamera {
                let flippedImage = UIImage(cgImage: (image?.cgImage)!, scale: (image?.scale)!, orientation: .leftMirrored)
                previewVC.image = flippedImage
            }
        }
    }
    
    

}

extension PhotoCameraVC: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            image = UIImage(data: imageData)
            self.performSegue(withIdentifier: "toPicPreview", sender: nil)
        }
    }
    
}
