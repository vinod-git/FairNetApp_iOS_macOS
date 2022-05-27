//
//  SelectServiceVideoCompare.h
//  FairNetApp
//
//  Created by Vinod Sarjerao Khandkar on 31/10/20.
//

#import <UIKit/UIKit.h>
#import "fn_globals_if.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectServiceVideoCompare : UIViewController
@property (nonatomic, assign) fn_apps svscTapp;
@property (nonatomic, assign) FnGeoLocation svscGloc;
@property (weak, nonatomic) IBOutlet UISwitch *HSVCRBButton;
@property (weak, nonatomic) IBOutlet UISwitch *YTVCRBButton;
@property (weak, nonatomic) IBOutlet UISwitch *NFVCRBButton;
@property (weak, nonatomic) IBOutlet UISwitch *PVVCRBButton;
@property (weak, nonatomic) IBOutlet UISwitch *MPVCRBButton;
@property (weak, nonatomic) IBOutlet UISwitch *HUVCRBButton;
@property (weak, nonatomic) IBOutlet UISwitch *VTVCRBButton;
@property (weak, nonatomic) IBOutlet UISwitch *Z5VCRBButton;
@property (weak, nonatomic) IBOutlet UISwitch *ENVCRBButton;
@property (weak, nonatomic) IBOutlet UISwitch *SLVCRBButtton;
- (IBAction)HSVCRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)YTVCRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)NFVCRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)PVVCRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)MPVCRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)HUVCRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)VTVCRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)Z5VCRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)ENVCRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)SLVCRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
-(IBAction)SelectVideoServiceCompareBackPressed:(UIBarButtonItem *)sender;
- (IBAction)SelectVideoServiceRun:(UIButton *)sender forEvent:(UIEvent *)event;

@end

NS_ASSUME_NONNULL_END
