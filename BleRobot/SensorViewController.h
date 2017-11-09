//
//  SensorViewController.h
//  BleRobot
//
//  Created by zh dk on 2017/11/6.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SensorViewController : UIViewController<UIAccelerometerDelegate>
{
    IBOutlet UILabel *xlabel;
    IBOutlet UILabel *ylabel;
    IBOutlet UILabel *zlabel;
}
@end
