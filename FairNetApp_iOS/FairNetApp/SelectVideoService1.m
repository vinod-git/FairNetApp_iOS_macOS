//
//  SelectVideoService.m
//  FairNetApp
//
//  Created by Vinod Sarjerao Khandkar on 29/10/20.
//

#import "SelectVideoService.h"

@interface SelectVideoService ()

@end

@implementation SelectVideoService

fn_apps tapp  = INVALID_APP;
int count = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) fn_svs_reset_buttons: (fn_apps) tapp {
    if (tapp != HOTSTAR)
        [_HSRBButton setOn:FALSE animated:TRUE];
    if (tapp != YOUTUBE)
        [_YTRBButton setOn:FALSE animated:TRUE];
    if (tapp != NETFLIX)
        [_NFRBButton setOn:FALSE animated:TRUE];
    if (tapp != PRIMEVIDEO)
        [_PVRBButton setOn:FALSE animated:TRUE];
}

- (void) fn_set_button_status: (fn_apps) app {
    tapp = app;
    [self fn_svs_reset_buttons: tapp];
}

- (IBAction)PVRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self fn_set_button_status: PRIMEVIDEO];
}

- (IBAction)NFRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self fn_set_button_status: NETFLIX];
}

- (IBAction)YTRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self fn_set_button_status: YOUTUBE];
}

- (IBAction)HSRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self fn_set_button_status: HOTSTAR];
}
@end
