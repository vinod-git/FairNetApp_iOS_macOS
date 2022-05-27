//
//  SelectAudioService.m
//  FairNetApp
//
//  Created by Vinod Sarjerao Khandkar on 02/12/20.
//

#import "SelectAudioService.h"
#import "SelectServiceType.h"
#import "SelectServiceAudioCompare.h"
#import "TestStatus.h"

@interface SelectAudioService ()

@end

@implementation SelectAudioService

fn_apps sasTapp  = INVALID_APP;
FnGeoLocation sasGloc = INVALID_LOC;
NSMutableArray *SasAppList;

- (void) SasInitDb {
    sasTapp = INVALID_APP;
    sasGloc = INVALID_LOC;
    SasAppList = [[NSMutableArray alloc] init];
}

- (void) SasResetDb {
    sasTapp = INVALID_APP;
    sasGloc = INVALID_LOC;
    SasAppList = nil;
}

- (void) SasGetData {
    sasTapp = _sasTapp;
    sasGloc = _sasGloc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self SasInitDb];
    [self SasGetData];
    [self fnSasSetButtons : sasTapp];
}

- (void) fnSasSetButtons: (fn_apps) cApp {
    switch (cApp) {
        case GAANA_COM:
            [fn_globals FnSetButton : _GCRBButton];
            break;
        case WYNK:
            [fn_globals FnSetButton : _WYRBButton];
            break;
        case SPOTIFY:
            [fn_globals FnSetButton : _SPRBButton];
            break;
        case SAAVN:
            [fn_globals FnSetButton : _SVRBButton];
            break;
        case PRIMEMUSIC:
            [fn_globals FnSetButton : _PMRBButton];
            break;
        default:
            break;
    }
}

- (void) fnSasResetButtons {
    [fn_globals FnResetButton : _GCRBButton];
    [fn_globals FnResetButton : _WYRBButton];
    [fn_globals FnResetButton : _SPRBButton];
    [fn_globals FnResetButton : _SVRBButton];
    [fn_globals FnResetButton : _PMRBButton];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) FillAppList {
    int i;
    int pApp = INVALID_APP;
    [SasAppList addObject:[NSNumber numberWithInt : sasTapp]];
    for (i=0; i< MAX_OTH_SERV; i++) {
        int cApp = INVALID_APP;
        // Generate random number/App
        while (true) {
            int appRange = MAX_AUD_SERVICE_APP - MIN_AUD_SERVICE_APP + 1;
            cApp = [fn_globals FnGenRandomNumber : MIN_AUD_SERVICE_APP : appRange];
            if (pApp != cApp && cApp != sasTapp) {
                pApp = cApp;
                break;
            }
        }
        // Add to list if not added earlier else genearate new App
        [SasAppList addObject:[NSNumber numberWithInt : cApp]];
    }
}


- (IBAction)SelectAudioServiceCompare:(UIButton *)sender forEvent:(UIEvent *)event {
    if (sasTapp == INVALID_APP || sasTapp == INIT_APP) {
        [fn_globals FnShowAlert: self : @"Error" :@"Please select a service"];
    } else {
        /*
        [self performSegueWithIdentifier:@"SAS2SASC" sender:self];
        SelectServiceAudioCompare * vc = [[SelectServiceAudioCompare alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
         */
        // Fill App list
        [self FillAppList];
        // Start test status
        [self performSegueWithIdentifier:@"SAS2TS" sender:self];
        TestStatus * vc = [[TestStatus alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (IBAction)SelectAudioServiceBackPressed:(UIBarButtonItem *)sender {
    SelectServiceType* vc =[self.storyboard instantiateViewControllerWithIdentifier:@"SelectServiceType"];
    vc.SstGloc = sasGloc;
    [self SasResetDb];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)PMRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : PRIMEMUSIC];
}

- (IBAction)SVRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : SAAVN];
}

- (IBAction)SPRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : SPOTIFY];
}

- (IBAction)WYRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : WYNK];
}

- (IBAction)GCRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    [self HandleRBButtonPressed : sender : GAANA_COM];
}

- (void) HandleRBButtonPressed : (UISwitch *)sender : (fn_apps) cApp {
    if (cApp == sasTapp) {
        [fn_globals  FnResetButton: sender];
        sasTapp = INIT_APP;
    }
    else {
        [self fnSasResetButtons];
        [fn_globals FnSetButton : sender];
        sasTapp = cApp;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"SAS2SASC"]){
        SelectServiceAudioCompare *dctrl = (SelectServiceAudioCompare *)segue.destinationViewController;
        dctrl.sascTapp = sasTapp;
        dctrl.sascGloc = sasGloc;
        [self SasResetDb];
    }
    if([segue.identifier isEqualToString:@"SAS2TS"]){
        TestStatus *dctrl = (TestStatus *)segue.destinationViewController;
        dctrl.TsApp = sasTapp;
        dctrl.TsAppList = SasAppList;
        dctrl.TsGloc = sasGloc;
        [self SasResetDb];
    }
}

@end
