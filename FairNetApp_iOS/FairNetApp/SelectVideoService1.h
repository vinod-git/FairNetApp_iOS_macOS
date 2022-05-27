//
//  SelectVideoService.h
//  FairNetApp
//
//  Created by Vinod Sarjerao Khandkar on 29/10/20.
//

#import <UIKit/UIKit.h>
#include "fn_globals_if.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectVideoService : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *HSRBButton;
@property (weak, nonatomic) IBOutlet UISwitch *YTRBButton;
@property (weak, nonatomic) IBOutlet UISwitch *NFRBButton;
@property (weak, nonatomic) IBOutlet UISwitch *PVRBButton;
- (IBAction)HSRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)YTRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)NFRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)PVRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;

@end

NS_ASSUME_NONNULL_END
