//
//  GetGeoLocation.h
//  FairNetApp
//
//  Created by Vinod Sarjerao Khandkar on 22/11/20.
//

#import <UIKit/UIKit.h>
#import "fn_globals_if.h"

NS_ASSUME_NONNULL_BEGIN

@interface GetGeoLocation : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *AFRBButton;
@property (weak, nonatomic) IBOutlet UISwitch *AMRBButton;
@property (weak, nonatomic) IBOutlet UISwitch *ASRBButton;
@property (weak, nonatomic) IBOutlet UISwitch *AURBButton;
@property (weak, nonatomic) IBOutlet UISwitch *EURBButton;
- (IBAction)AFRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)AMRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)ASRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)AURBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)EURBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;
@property (nonatomic, assign) FnGeoLocation gglGeoLoc;
- (IBAction)NextButtonPressed:(UIButton *)sender forEvent:(UIEvent *)event;
@end

NS_ASSUME_NONNULL_END
