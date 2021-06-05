//
//  StatusViewController.swift
//  ServerTest
//
//  Created by Ritik Suryawanshi on 05/06/21.
//

import UIKit
import CorePlot
import Firebase



class StatusViewController: UIViewController, CALayerDelegate {
   
    var ref : DatabaseReference!
    var plotData = [Double](repeating: 0.0, count: 1000)
      var plot: CPTScatterPlot!
      var maxDataPoints = 10
    var frameRate = 5.0
      var alphaValue = 0.25
      var timer : Timer?
      var currentIndex: Int!
    var timeDuration:Double = 1.0
    var td: Int = 1
    var point: Double = 0.0
    var accuracy: [Double] = [92.9,95.2,82.3,93.3,89.9]
    var cs: [Double] = [4.1,9.8,2.3,12.7,3.9]
    var lms_value: [Double] = [23.83,36.10,56.72,63.84,68.47]
    var status : Bool = true

    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var serverActive: UILabel!
    
    @IBOutlet var mbLabel: UILabel!
    @IBOutlet var Connect: UIButton!
    @IBOutlet var graphView: CPTGraphHostingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Connect.isHidden = true
        mbLabel.isHidden = true
        timeLabel.isHidden = true
        serverActive.isHidden = false
        styleHollowButton(Connect)
        checkStatus()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        Connect.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkStatus()
    }
    func checkButton() {
        graphView.isHidden = false
        Connect.isHidden = false
        mbLabel.isHidden = false
        timeLabel.isHidden = false
        serverActive.isHidden = true
    }
    func mrIndia(){
        Connect.isHidden = true
        mbLabel.isHidden = true
        timeLabel.isHidden = true
        serverActive.isHidden = false
        graphView.isHidden = true
    }
    func checkStatus (){
        guard let uid = Auth.auth().currentUser?.uid else
             {
                 return
             }
             ref = Database.database().reference()
             let userReference = ref.child("users").child(uid)
             
             userReference.observeSingleEvent(of: .value, with: { (snapshot) in
             
             if let dictionary = snapshot.value as? [String: AnyObject]
              {
                  let statusText = dictionary["status"] as! String
                if(statusText == "true")
                {
                    self.checkButton()
                    self.initializeGraph()
                    
                }
                else
                {
                    self.mrIndia()
                }
             }
                
                      })
        
        
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil){
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: self.timeDuration, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        }
        
        @objc func fireTimer(){
            td = td + 1;
            let graph = self.graphView.hostedGraph
            let plot = graph?.plot(withIdentifier: "mindful-graph" as NSCopying)
            if((plot) != nil){
                if(self.plotData.count >= maxDataPoints){
                    self.plotData.removeFirst()
                    plot?.deleteData(inIndexRange:NSRange(location: 0, length: 1))
                }
            }
            guard let plotSpace = graph?.defaultPlotSpace as? CPTXYPlotSpace else { return }
            
            let location: NSInteger
            if self.currentIndex >= maxDataPoints {
                location = self.currentIndex - maxDataPoints + 2
            } else {
                location = 0
            }
            
            let range: NSInteger
            
            if location > 0 {
                range = location-1
            } else {
                range = 0
            }
            
            let oldRange =  CPTPlotRange(locationDecimal: CPTDecimalFromDouble(Double(range)), lengthDecimal: CPTDecimalFromDouble(Double(maxDataPoints-2)))
            let newRange =  CPTPlotRange(locationDecimal: CPTDecimalFromDouble(Double(location)), lengthDecimal: CPTDecimalFromDouble(Double(maxDataPoints-2)))
        
            CPTAnimation.animate(plotSpace, property: "xRange", from: oldRange, to: newRange, duration:0.3)
            
            self.currentIndex += 1;
            point = Double.random(in: 60...100)
            if(td > 14 && td < 30)
            {
            point = Double.random(in: 500...780)
                
            }
            self.plotData.append(point)
            plot?.insertData(at: UInt(self.plotData.count-1), numberOfRecords: 1)
            if(td==17)
            {
                let a = accuracy.randomElement()
                let b = cs.randomElement()
                let c = lms_value.randomElement()
                
                let mess = "DDOS attack has been detected \n Accuracy: \(String(describing: a)) \n C/s: \(String(describing: b)) \n lms_value: \(String(describing: c))"
                
                let alertController = UIAlertController(title: "Warning", message: mess, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    
  
    func initializeGraph(){
            configureGraphtView()
            configurePlot()
        }
           
        func configureGraphtView(){
            graphView.allowPinchScaling = false
            self.plotData.removeAll()
            self.currentIndex = 0
                    
            //Configure graph
            let graph = CPTXYGraph(frame: graphView.bounds)
            graph.plotAreaFrame?.masksToBorder = false
            graphView.hostedGraph = graph
            graph.backgroundColor = UIColor.black.cgColor
            graph.paddingBottom = 40.0
            graph.paddingLeft = 40.0
            graph.paddingTop = 30.0
            graph.paddingRight = 15.0
            
            //Style for graph title
            let titleStyle = CPTMutableTextStyle()
            titleStyle.color = CPTColor.white()
            titleStyle.fontName = "HelveticaNeue-Bold"
            titleStyle.fontSize = 20.0
            titleStyle.textAlignment = .center
            graph.titleTextStyle = titleStyle

            //Set graph title
            let title = "SERVER-TRAFFIC"
            graph.title = title
            graph.titlePlotAreaFrameAnchor = .top
            graph.titleDisplacement = CGPoint(x: 0.0, y: 0.0)
            
            let axisSet = graph.axisSet as! CPTXYAxisSet
                    
            let axisTextStyle = CPTMutableTextStyle()
            axisTextStyle.color = CPTColor.white()
            axisTextStyle.fontName = "HelveticaNeue-Bold"
            axisTextStyle.fontSize = 10.0
            axisTextStyle.textAlignment = .center
            let lineStyle = CPTMutableLineStyle()
            lineStyle.lineColor = CPTColor.white()
            lineStyle.lineWidth = 5
            let gridLineStyle = CPTMutableLineStyle()
            gridLineStyle.lineColor = CPTColor.gray()
            gridLineStyle.lineWidth = 0.5


            if let x = axisSet.xAxis {
                x.majorIntervalLength   = 1
                x.minorTicksPerInterval = 5
                x.labelTextStyle = axisTextStyle
                x.minorGridLineStyle = gridLineStyle
                x.axisLineStyle = lineStyle
                x.axisConstraints = CPTConstraints(lowerOffset: 0.0)
                x.delegate = self
            }

            if let y = axisSet.yAxis {
                y.majorIntervalLength   = 20
                y.minorTicksPerInterval = 5
                y.minorGridLineStyle = gridLineStyle
                y.labelTextStyle = axisTextStyle
                y.alternatingBandFills = [CPTFill(color: CPTColor.init(componentRed: 255, green: 255, blue: 255, alpha: 0.03)),CPTFill(color: CPTColor.black())]
                y.axisLineStyle = lineStyle
                y.axisConstraints = CPTConstraints(lowerOffset: 0.0)
                y.delegate = self
            }
            
            let xMin = 0.0
            let xMax = 10.0
            let yMin = 0.0
            let yMax = 800.0
            guard let plotSpace = graph.defaultPlotSpace as? CPTXYPlotSpace else { return }
            plotSpace.xRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(xMin), lengthDecimal: CPTDecimalFromDouble(xMax - xMin))
            plotSpace.yRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(yMin), lengthDecimal: CPTDecimalFromDouble(yMax - yMin))
            
           
        }
    func configurePlot(){
            plot = CPTScatterPlot()
            let plotLineStile = CPTMutableLineStyle()
            plotLineStile.lineJoin = .round
            plotLineStile.lineCap = .round
            plotLineStile.lineWidth = 2
            plotLineStile.lineColor = CPTColor.white()
            plot.dataLineStyle = plotLineStile
            plot.curvedInterpolationOption = .catmullCustomAlpha
            plot.interpolation = .curved
            plot.identifier = "mindful-graph" as NSCoding & NSCopying & NSObjectProtocol
            guard let graph = graphView.hostedGraph else { return }
            plot.dataSource = (self as CPTPlotDataSource)
            plot.delegate = (self as CALayerDelegate)
            graph.add(plot, to: graph.defaultPlotSpace)
        }
    
    func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.green.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.green
    }
    
    @IBAction func connectPressed(_ sender: Any) {
        
       
    }
    
    }

    extension StatusViewController: CPTScatterPlotDataSource, CPTScatterPlotDelegate {
        func numberOfRecords(for plot: CPTPlot) -> UInt {
            return UInt(self.plotData.count)
        }

        func number(for plot: CPTPlot, field: UInt, record: UInt) -> Any? {
           switch CPTScatterPlotField(rawValue: Int(field))! {
                case .X:
                    return NSNumber(value: Int(record) + self.currentIndex-self.plotData.count)
                case .Y:
                    return self.plotData[Int(record)] as NSNumber
                default:
                    return 0
            }
        }
    }




    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


