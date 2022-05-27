//
//  SelectServiceVideoCompare.m
//  FairNetApp
//
//  Created by Vinod Sarjerao Khandkar on 31/10/20.
//

#import "SelectServiceVideoCompare.h"
#import "TestStatus.h"
#import "SelectVideoService.h"

@interface SelectServiceVideoCompare ()

@end

@implementation SelectServiceVideoCompare

fn_apps svscTapp  = INVALID_APP;
FnGeoLocation svscGloc = INVALID_LOC;
NSMutableArray *SvscAppList;

- (void) fnSvscSetButtons: (fn_apps) cApp {
    switch (cApp) {
        case HOTSTAR:
            [_HSVCRBButton setOn:TRUE animated:TRUE];
            [_HSVCRBButton setEnabled:NO];
            break;
        case YOUTUBE:
            [_YTVCRBButton setOn:TRUE animated:TRUE];
            [_YTVCRBButton setEnabled:NO];
            break;
        case NETFLIX:
            [_NFVCRBButton setOn:TRUE animated:TRUE];
            [_NFVCRBButton setEnabled:NO];
            break;
        case PRIMEVIDEO:
            [_PVVCRBButton setOn:TRUE animated:TRUE];
            [_PVVCRBButton setEnabled:NO];
            break;
        case MXPLAYER:
            [_MPVCRBButton setOn:TRUE animated:TRUE];
            [_MPVCRBButton setEnabled:NO];
            break;
        case HUNGAMA:
            [_HUVCRBButton setOn:TRUE animated:TRUE];
            [_HUVCRBButton setEnabled:NO];
            break;
        case ZEE5:
            [_Z5VCRBButton setOn:TRUE animated:TRUE];
            [_Z5VCRBButton setEnabled:NO];
            break;
        case VOOT:
            [_VTVCRBButton setOn:TRUE animated:TRUE];
            [_VTVCRBButton setEnabled:NO];
            break;
        case EROSNOW:
            [_ENVCRBButton setOn:TRUE animated:TRUE];
            [_ENVCRBButton setEnabled:NO];
            break;
        case SONYLIV:
            [_SLVCRBButtton setOn:TRUE animated:TRUE];
            [_SLVCRBButtton setEnabled:NO];
            break;
        default:
            break;
    }
}

- (void) SvscInitDb {
    svscTapp = INVALID_APP;
    svscGloc = INVALID_LOC;
    SvscAppList = [[NSMutableArray alloc] init];
}

- (void) SvscResetDb {
    svscTapp = INVALID_APP;
    svscGloc = INVALID_LOC;
    SvscAppList = nil;
}

- (void) SvscGetData {
    svscTapp = _svscTapp;
    svscGloc = _svscGloc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self SvscInitDb];
    [self SvscGetData];
    [SvscAppList addObject:[NSNumber numberWithInt : svscTapp]];
    [self fnSvscSetButtons: svscTapp];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) SvscSetBackwardData : (SelectVideoService*) vc {
    vc.svsTapp = svscTapp;
    vc.svsGloc = svscGloc;
}

- (IBAction)SelectVideoServiceRun:(UIButton *)sender forEvent:(UIEvent *)event {
    long numApps = [SvscAppList count];
    if (numApps == 1) {
        [fn_globals FnShowAlert: self : @"Error" :@"Please select more services"];
    } else {
        [self performSegueWithIdentifier:@"VRT" sender:self];
        TestStatus * vc = [[TestStatus alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (IBAction)SelectVideoServiceCompareBackPressed:(UIBarButtonItem *)sender {
    SelectVideoService* vc =[self.storyboard instantiateViewControllerWithIdentifier:@"SelectVideoService"];
    [self SvscSetBackwardData : vc];
    [SvscAppList removeAllObjects];
    [self SvscResetDb];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)SLVCRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : SONYLIV];
}

- (IBAction)ENVCRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : EROSNOW];
}

- (IBAction)Z5VCRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : ZEE5];
}

- (IBAction)VTVCRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : VOOT];
}

- (IBAction)HUVCRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : HUNGAMA];
}

- (IBAction)MPVCRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : MXPLAYER];
}

- (IBAction)PVVCRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : PRIMEVIDEO];
}

- (IBAction)NFVCRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : NETFLIX];
}

- (IBAction)YTVCRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : YOUTUBE];
}


- (IBAction)HSVCRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : HOTSTAR];
}

- (void) HandleRBButtonPressed : (UISwitch *)sender : (fn_apps) cApp {
    sender.selected = !sender.selected;
    if (sender.selected) {
        if (cApp != svscTapp) {
            [SvscAppList addObject:[NSNumber numberWithInt : cApp]];
        }
    } else {
        if (cApp != svscTapp) {
            [SvscAppList removeObject:[NSNumber numberWithInt : cApp]];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"VRT"]){
        TestStatus *dctrl = (TestStatus *)segue.destinationViewController;
        dctrl.TsApp = svscTapp;
        dctrl.TsAppList = SvscAppList;
        dctrl.TsGloc = svscGloc;
        [self SvscResetDb];
    }
}
@end
