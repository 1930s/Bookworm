//
//  ViewController.swift
//  BarcodeScanning
//
//  THIS IS NOT MY CODE
//
//  ADDAPTED FOM GITHUB PROJECTS AND STACK OVERFLOW
//
//  Created by Jordan Morgan on 5/16/15.
//  Copyright (c) 2015 Jordan Morgan. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate
{
    
    @IBOutlet weak var cameraView: UIView!
    
    var first = true
    
    var isbn : String = ""
    
    //MARK: Properties
    let captureSession = AVCaptureSession()
    var captureDevice:AVCaptureDevice?
    var captureLayer:AVCaptureVideoPreviewLayer?
    
    //MARK: View lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        self.setupCaptureSession()
        
    }
    
    //MARK: Session Startup
    fileprivate func setupCaptureSession()
    {
        self.captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do{
            let deviceInput = try AVCaptureDeviceInput(device: self.captureDevice)
            
            //Add the input feed to the session and start it
            if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
                for input in inputs {
                    captureSession.removeInput(input)
                }
            }
            if captureSession.inputs.isEmpty {
                self.captureSession.addInput(deviceInput)
            }
            self.setupPreviewLayer({
                self.captureSession.startRunning()
                self.addMetaDataCaptureOutToSession()
            })
        }
        catch
        {
            //self.showError(error.localizedDescription)
        }
        
    }
    
    fileprivate func setupPreviewLayer(_ completion:() -> ())
    {
        self.captureLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        
        if let capLayer = self.captureLayer
        {
            capLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            capLayer.frame = self.cameraView.frame
            self.view.layer.addSublayer(capLayer)
            completion()
        }
        else
        {
            self.showError("An error occured beginning video capture.")
        }
    }
    
    //MARK: Metadata capture
    fileprivate func addMetaDataCaptureOutToSession()
    {
        let metadata = AVCaptureMetadataOutput()
        self.captureSession.addOutput(metadata)
        metadata.metadataObjectTypes = metadata.availableMetadataObjectTypes
        metadata.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
    }
    
    //MARK: Delegate Methods
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!)
    {
        for metaData in metadataObjects
        {
            if let decodedData:AVMetadataMachineReadableCodeObject = metaData as? AVMetadataMachineReadableCodeObject{
                isbn = decodedData.stringValue
            }
        }
        
        if first{
            self.performSegue(withIdentifier: "foundCode", sender: true)
            first = false
        }
    }
    
    //MARK: Utility Functions
    fileprivate func showError(_ error:String)
    {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let dismiss:UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler:{(alert:UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(dismiss)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func enterManually(_ sender: AnyObject) {
        performSegue(withIdentifier: "foundCode", sender: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let bookDetails = segue.destination as? NewBookFormViewController {
            bookDetails.hasISBN = sender as! Bool!
            bookDetails.isbn = self.isbn
        }
    }
}

