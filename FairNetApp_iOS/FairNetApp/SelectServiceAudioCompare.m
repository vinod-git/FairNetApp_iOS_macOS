//
//  SelectServiceAudioCompare.m
//  FairNetApp
//
//  Created by Vinod Sarjerao Khandkar on 02/12/20.
//

#import "SelectServiceAudioCompare.h"
#import "SelectAudioService.h"
#import "TestStatus.h"

@interface SelectServiceAudioCompare ()

@end

@implementation SelectServiceAudioCompare

fn_apps sascTapp  = INVALID_APP;
FnGeoLocation sascGloc = INVALID_LOC;
NSMutableArray *SascAppList;

- (void) fnSvscSetButtons: (fn_apps) cApp {
    switch (cApp) {
        case GAANA_COM:
            [_GCACRBButton setOn:TRUE animated:TRUE];
            [_GCACRBButton setEnabled:NO];
            break;
        case WYNK:
            [_WYACRBButton setOn:TRUE animated:TRUE];
            [_WYACRBButton setEnabled:NO];
            break;
        case SPOTIFY:
            [_SPACRBButton setOn:TRUE animated:TRUE];
            [_SPACRBButton setEnabled:NO];
            break;
        case SAAVN:
            [_SVACRBButton setOn:TRUE animated:TRUE];
            [_SVACRBButton setEnabled:NO];
            break;
        default:
            break;
    }
}

- (void) SascInitDb {
    sascTapp = INVALID_APP;
    sascGloc = INVALID_LOC;
    SascAppList = [[NSMutableArray alloc] init];
}

- (void) SascResetDb {
    sascTapp = INVALID_APP;
    sascGloc = INVALID_LOC;
    SascAppList = nil;
}

- (void) SascGetData {
    sascTapp = _sascTapp;
    sascGloc = _sascGloc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self SascInitDb];
    [self SascGetData];
    [SascAppList addObject:[NSNumber numberWithInt : sascTapp]];
    [self fnSvscSetButtons: sascTapp];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) SascSetBackwardData : (SelectAudioService*) vc {
    vc.sasTapp = sascTapp;
    vc.sasGloc = sascGloc;
}

- (IBAction)SelectServiceAudioRun:(UIButton *)sender forEvent:(UIEvent *)event {
    long numApps = [SascAppList count];
    if (numApps == 1) {
        [fn_globals FnShowAlert: self : @"Error" :@"Please select more services"];
    } else {
        [self performSegueWithIdentifier:@"ART" sender:self];
        TestStatus * vc = [[TestStatus alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (IBAction)SelectServieAudioBackPressed:(UIBarButtonItem *)sender {
    SelectAudioService* vc =[self.storyboard instantiateViewControllerWithIdentifier:@"SelectAudioService"];
    [self SascSetBackwardData : vc];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)PMACRBButton:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : PRIMEMUSIC];
}

- (IBAction)SVACRBButton:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : SAAVN];
}

- (IBAction)SPACRBButton:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : SPOTIFY];
}

- (IBAction)WYACRBButton:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : WYNK];
}

- (IBAction)GCAVRBButton:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : GAANA_COM];
}

- (void) HandleRBButtonPressed : (UISwitch *)sender : (fn_apps) cApp {
    sender.selected = !sender.selected;
    if (sender.selected) {
        if (cApp != sascTapp) {
            [SascAppList addObject:[NSNumber numberWithInt : cApp]];
        }
    } else {
        if (cApp != sascTapp) {
            [SascAppList removeObject:[NSNumber numberWithInt : cApp]];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ART"]){
        TestStatus *dctrl = (TestStatus *)segue.destinationViewController;
        dctrl.TsApp = sascTapp;
        dctrl.TsAppList = SascAppList;
        dctrl.TsGloc = sascGloc;
        [self SascResetDb];
    }
}

@end
