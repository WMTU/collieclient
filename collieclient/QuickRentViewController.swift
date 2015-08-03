//
//  SecondViewController.swift
//  collieclient
//
//  Created by Neil Betham on 8/2/15.
//  Copyright (c) 2015 wmtu. All rights reserved.
//

import UIKit
import AVFoundation

class QuickRentViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UITableViewDelegate, UITableViewDataSource {

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    let session         : AVCaptureSession = AVCaptureSession()
    var previewLayer    : AVCaptureVideoPreviewLayer!
    var highlightView   : UIView = UIView()
    var barCodes        : [String] = []
    
    @IBOutlet var scannerPreview: UIView!
    @IBOutlet var barcodeScanList: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Allow the view to resize freely
        self.highlightView.autoresizingMask =   UIViewAutoresizing.FlexibleTopMargin |
            UIViewAutoresizing.FlexibleBottomMargin |
            UIViewAutoresizing.FlexibleLeftMargin |
            UIViewAutoresizing.FlexibleRightMargin
        
        // Select the color you want for the completed scan reticle
        self.highlightView.layer.borderColor = UIColor.greenColor().CGColor
        self.highlightView.layer.borderWidth = 3
        
        // Add it to our controller's view as a subview.
        scannerPreview.addSubview(self.highlightView)
        
        
        // For the sake of discussion this is the camera
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Create a nilable NSError to hand off to the next method.
        // Make sure to use the "var" keyword and not "let"
        var error : NSError? = nil
        
        
        let input : AVCaptureDeviceInput? = AVCaptureDeviceInput.deviceInputWithDevice(device, error: &error) as? AVCaptureDeviceInput
        
        // If our input is not nil then add it to the session, otherwise we're kind of done!
        if input != nil {
            session.addInput(input)
        }
        else {
            // This is fine for a demo, do something real with this in your app. :)
            println(error)
        }
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.addOutput(output)
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        
        previewLayer = AVCaptureVideoPreviewLayer.layerWithSession(session) as! AVCaptureVideoPreviewLayer
        previewLayer.frame = scannerPreview.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        scannerPreview.layer.addSublayer(previewLayer)
        
        
        // Start the scanner. You'll have to end it yourself later.
        session.startRunning()
        
        barcodeScanList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // This is called when we find a known barcode type with the camera.
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        var highlightViewRect = CGRectZero
        
        var barCodeObject : AVMetadataObject!
        
        var detectionString : String!
        
        let barCodeTypes = [AVMetadataObjectTypeUPCECode,
            AVMetadataObjectTypeCode39Code,
            AVMetadataObjectTypeCode39Mod43Code,
            AVMetadataObjectTypeEAN13Code,
            AVMetadataObjectTypeEAN8Code,
            AVMetadataObjectTypeCode93Code,
            AVMetadataObjectTypeCode128Code,
            AVMetadataObjectTypePDF417Code,
            AVMetadataObjectTypeQRCode,
            AVMetadataObjectTypeAztecCode
        ]
        
        
        // The scanner is capable of capturing multiple 2-dimensional barcodes in one scan.
        for metadata in metadataObjects {
            for barcodeType in barCodeTypes {
                if metadata.type == barcodeType {
                    barCodeObject = self.previewLayer.transformedMetadataObjectForMetadataObject(metadata as! AVMetadataMachineReadableCodeObject)
                    
                    highlightViewRect = barCodeObject.bounds
                    
                    detectionString = (metadata as! AVMetadataMachineReadableCodeObject).stringValue
                    
                    break
                }
            }
        }
        
        if detectionString != nil {
            barCodes.insert(detectionString, atIndex: 0)
            
            barcodeScanList.reloadData()
        }
        
        self.highlightView.frame = highlightViewRect
        scannerPreview.bringSubviewToFront(self.highlightView)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barCodes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = barcodeScanList.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel?.text = self.barCodes[indexPath.row]
        
        return cell
    }
}

