//
//  SelectAudioService.h
//  FairNetApp
//
//  Created by Vinod Sarjerao Khandkar on 02/12/20.
//

#import <UIKit/UIKit.h>
#import "fn_globals_if.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectAudioService : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *GCRBButton;
@property (weak, nonatomic) IBOutlet UISwitch *WYRBButton;
@property (weak, nonatomic) IBOutlet UISwitch *SPRBButton;
@property (weak, nonatomic) IBOutlet UISwitch *SVRBButton;
@property (weak, nonatomic) IBOutlet UISwitch *PMRBButton;
@property (weak, nonatomic) IBOutlet UIButton *SelectAudioService;
- (IBAction)SelectAudioServiceCompare:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)GCRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)WYRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)SPRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)SVRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)PMRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)SelectAudioServiceBackPressed:(UIBarButtonItem *)sender;
@property (nonatomic, assign) FnGeoLocation sasGloc;
@property (nonatomic, assign) fn_apps sasTapp;
@end

NS_ASSUME_NONNULL_END
