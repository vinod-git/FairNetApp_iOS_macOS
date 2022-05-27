//
//  SelectServiceAudioCompare.h
//  FairNetApp
//
//  Created by Vinod Sarjerao Khandkar on 02/12/20.
//

#import <UIKit/UIKit.h>
#import "fn_globals_if.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectServiceAudioCompare : UIViewController
@property (nonatomic, assign) fn_apps sascTapp;
@property (nonatomic, assign) FnGeoLocation sascGloc;
@property (weak, nonatomic) IBOutlet UISwitch *GCACRBButton;
@property (weak, nonatomic) IBOutlet UISwitch *WYACRBButton;
@property (weak, nonatomic) IBOutlet UISwitch *SPACRBButton;
@property (weak, nonatomic) IBOutlet UISwitch *SVACRBButton;
@property (weak, nonatomic) IBOutlet UISwitch *PMACRBButton;
- (IBAction)GCAVRBButton:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)WYACRBButton:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)SPACRBButton:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)SVACRBButton:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)PMACRBButton:(UISwitch *)sender forEvent:(UIEvent *)event;
-(IBAction)SelectServieAudioBackPressed:(UIBarButtonItem *)sender;
- (IBAction)SelectServiceAudioRun:(UIButton *)sender forEvent:(UIEvent *)event;
@end

NS_ASSUME_NONNULL_END
