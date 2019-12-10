import UIKit

class AdMainVC: PlateVC {
    @IBOutlet var myView: [UIView]!
    var job_no = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setBarButtonItem()
        self.myView[0].isHidden = false
        self.myView[1].isHidden = true
        // Do any additional setup after loading the view.
        job_no = getJob()
        if job_no == 2 {
            if let tabBarController = self.tabBarController {
                var viewControllers = tabBarController.viewControllers
                viewControllers?.remove(at: 0)
                viewControllers?.remove(at: 3)
                viewControllers?.remove(at: 1)
                tabBarController.viewControllers = viewControllers
            } }  else if job_no == 3{
            if let tabBarController = self.tabBarController {
                var viewControllers = tabBarController.viewControllers
                viewControllers?.remove(at: 1)
                viewControllers?.remove(at: 2)
                tabBarController.viewControllers = viewControllers
            } }
    }
    
    @IBAction func changeView(_ sender: UISegmentedControl) {
        self.myView[0].isHidden.toggle()
        self.myView[1].isHidden.toggle()
        
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    override func viewDidAppear(_ animated: Bool) {
        login()
    }
}



