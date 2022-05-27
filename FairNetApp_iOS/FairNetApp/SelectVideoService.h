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
@property (weak, nonatomic) IBOutlet UISwitch *MPRBButton;
@property (weak, nonatomic) IBOutlet UISwitch *HURBButton;
@property (weak, nonatomic) IBOutlet UISwitch *VTRBButton;
@property (weak, nonatomic) IBOutlet UISwitch *Z5RBButton;
@property (weak, nonatomic) IBOutlet UISwitch *ENRBButton;
@property (weak, nonatomic) IBOutlet UISwitch *SLRBButton;

- (IBAction)HSRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)YTRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)NFRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)PVRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)MPRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)HURBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)VTRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)Z5RBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)ENRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)SLRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;

@property (nonatomic, assign) int newcount;
@property (nonatomic, assign) fn_apps svsTapp;
@property (nonatomic, assign) FnGeoLocation svsGloc;
- (IBAction)SelectVideoServiceCompare:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *SelectVideoServiceCompare;
-(IBAction)SelectVideoServiceBackPressed:(UIBarButtonItem *)sender;
@end

NS_ASSUME_NONNULL_END
