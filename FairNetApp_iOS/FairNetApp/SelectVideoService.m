//
//  SelectVideoService.m
//  FairNetApp
//
//  Created by Vinod Sarjerao Khandkar on 29/10/20.
//

#import "SelectVideoService.h"
#import "SelectServiceVideoCompare.h"
#import "SelectServiceType.h"
#import "TestStatus.h"

@interface SelectVideoService ()

@end

@implementation SelectVideoService

fn_apps tapp  = INVALID_APP;
FnGeoLocation svsGloc = INVALID_LOC;
NSMutableArray *SvsAppList;

int cnt = 0;

- (void) SvsInitDb {
    tapp = INVALID_APP;
    svsGloc = INVALID_LOC;
    SvsAppList = [[NSMutableArray alloc] init];
}

- (void) SvsResetDb {
    tapp = INVALID_APP;
    svsGloc = INVALID_LOC;
    SvsAppList = nil;
}

- (void) SvsGetData {
    tapp = _svsTapp;
    svsGloc = _svsGloc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self SvsInitDb];
    [self SvsGetData];
    cnt = _newcount;
    [self fnSvsSetButtons : tapp];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) fnSvsSetButtons: (fn_apps) cApp {
    switch (cApp) {
        case HOTSTAR:
            [fn_globals FnSetButton : _HSRBButton];
            break;
        case YOUTUBE:
            [fn_globals FnSetButton : _YTRBButton];
            break;
        case NETFLIX:
            [fn_globals FnSetButton : _NFRBButton];
            break;
        case PRIMEVIDEO:
            [fn_globals FnSetButton : _PVRBButton];
            break;
        case MXPLAYER:
            [fn_globals FnSetButton : _MPRBButton];
            break;
        case HUNGAMA:
            [fn_globals FnSetButton : _HURBButton];
            break;
        case ZEE5:
            [fn_globals FnSetButton : _Z5RBButton];
            break;
        case VOOT:
            [fn_globals FnSetButton : _VTRBButton];
            break;
        case EROSNOW:
            [fn_globals FnSetButton : _ENRBButton];
            break;
        case SONYLIV:
            [fn_globals FnSetButton : _SLRBButton];
            break;
        default:
            break;
    }
}

- (void) fnSvsResetButtons {
    [fn_globals FnResetButton : _HSRBButton];
    [fn_globals FnResetButton : _YTRBButton];
    [fn_globals FnResetButton : _NFRBButton];
    [fn_globals FnResetButton : _PVRBButton];
    [fn_globals FnResetButton : _MPRBButton];
    [fn_globals FnResetButton : _HURBButton];
    [fn_globals FnResetButton : _Z5RBButton];
    [fn_globals FnResetButton : _VTRBButton];
    [fn_globals FnResetButton : _ENRBButton];
    [fn_globals FnResetButton : _SLRBButton];
}

- (void) HandleRBButtonPressed : (UISwitch *)sender : (fn_apps) cApp {
    if (cApp == tapp) {
        [fn_globals  FnResetButton: sender];
        tapp = INIT_APP;
    }
    else {
        [self fnSvsResetButtons];
        [fn_globals FnSetButton : sender];
        tapp = cApp;
    }
}


- (IBAction)SLRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : SONYLIV];
}

- (IBAction)ENRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : EROSNOW];
}

- (IBAction)Z5RBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : ZEE5];
}

- (IBAction)VTRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : VOOT];
}

- (IBAction)HURBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : HUNGAMA];
}

- (IBAction)MPRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : MXPLAYER];
}

- (IBAction)PVRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : PRIMEVIDEO];
}

- (IBAction)NFRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : NETFLIX];
}

- (IBAction)YTRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : YOUTUBE];
}

- (IBAction)HSRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : HOTSTAR];
}

- (void) FillAppList {
    int i;
    int pApp = INVALID_APP;
    [SvsAppList addObject:[NSNumber numberWithInt : tapp]];
    for (i=0; i< MAX_OTH_SERV; i++) {
        int cApp = INVALID_APP;
        // Generate random number/App
        while (true) {
            int appRange = MAX_VID_SERVICE_APP - MIN_VID_SERVICE_APP + 1;
            cApp = [fn_globals FnGenRandomNumber : MIN_VID_SERVICE_APP : appRange];
            if (pApp != cApp && cApp != tapp) {
                pApp = cApp;
                break;
            }
        }
        // Add to list if not added earlier else genearate new App
        [SvsAppList addObject:[NSNumber numberWithInt : cApp]];
    }
}

- (IBAction)SelectVideoServiceCompare:(UIButton *)sender forEvent:(UIEvent *)event {
    if (tapp == INVALID_APP || tapp == INIT_APP) {
        [fn_globals FnShowAlert: self : @"Error" :@"Please select a service"];
    } else {
        /*
        [self performSegueWithIdentifier:@"SVS2SVSC" sender:self];
        SelectServiceVideoCompare * vc = [[SelectServiceVideoCompare alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
         */
        // Fill App list
        [self FillAppList];
        // Start test status
        [self performSegueWithIdentifier:@"SVS2TS" sender:self];
        TestStatus * vc = [[TestStatus alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"SVS2SVSC"]){
        SelectServiceVideoCompare *dctrl = (SelectServiceVideoCompare *)segue.destinationViewController;
        dctrl.svscTapp = tapp;
        dctrl.svscGloc = svsGloc;
        [self SvsResetDb];
    }
    if([segue.identifier isEqualToString:@"SVS2TS"]){
        TestStatus *dctrl = (TestStatus *)segue.destinationViewController;
        dctrl.TsApp = tapp;
        dctrl.TsAppList = SvsAppList;
        dctrl.TsGloc = svsGloc;
        [self SvsResetDb];
    }
}
- (IBAction)SelectVideoServiceBackPressed:(UIBarButtonItem *)sender {
    SelectServiceType* vc =[self.storyboard instantiateViewControllerWithIdentifier:@"SelectServiceType"];
    vc.SstGloc = svsGloc;
    [self SvsResetDb];
    [self presentViewController:vc animated:YES completion:nil];
}
@end
