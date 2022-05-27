//
//  GetGeoLocation.m
//  FairNetApp
//
//  Created by Vinod Sarjerao Khandkar on 22/11/20.
//

#import "GetGeoLocation.h"
#import "SelectServiceType.h"
#import "DrawGraph.h"

@interface GetGeoLocation ()

@end

@implementation GetGeoLocation

FnGeoLocation geoLoc = INVALID_LOC;
fn_globals_if *fn_globals = nil;
DrawGraph *dG = nil;

- (void) GglGetData {
    geoLoc = _gglGeoLoc;
}

- (fn_globals_if*) GgInitGlobals {
    fn_globals_if* fn_globals = nil;
    fn_globals = [[fn_globals_if alloc] init];
    fn_globals->cnt = 0;
    [fn_globals FnInitGlobals : fn_globals];
    return fn_globals;
}

-(void) GgInitDrawGraph {
    dG->shapeLayerList = [[NSMutableArray alloc] init];
    dG->cViewList = [[NSMutableArray alloc] init];
}

- (DrawGraph*) GgGetDrawGraphPtr {
    DrawGraph* dG = nil;
    dG = [[DrawGraph alloc] init];
    return dG;
}

- (void) GglInitDb {
    fn_globals = nil;
    geoLoc = INVALID_LOC;
}

- (void) GglResetDb {
    geoLoc = INVALID_LOC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self GglInitDb];
    if (fn_globals == nil) {
        fn_globals = [self GgInitGlobals];
    }
    dG = [self GgGetDrawGraphPtr];
    [self GgInitDrawGraph];
    [self GglGetData];
    NSLog(@"Geo Location : %d", geoLoc);
    [self GglSetButtons : geoLoc];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) GglSetButtons: (FnGeoLocation) cGeoLoc {
    if (cGeoLoc == AFRICA)
        [_AFRBButton setOn:TRUE animated:TRUE];
    if (cGeoLoc == AMERICA)
        [_AMRBButton setOn:TRUE animated:TRUE];
    if (cGeoLoc == ASIA)
        [_ASRBButton setOn:TRUE animated:TRUE];
    if (cGeoLoc == AUSTRALIA)
        [_AURBButton setOn:TRUE animated:TRUE];
    if (cGeoLoc == EUROPE)
        [_EURBButton setOn:TRUE animated:TRUE];
}


- (void) GglResetButtons: (FnGeoLocation) cGeoLoc {
    if (cGeoLoc != AFRICA)
        [_AFRBButton setOn:FALSE animated:TRUE];
    if (cGeoLoc != AMERICA)
        [_AMRBButton setOn:FALSE animated:TRUE];
    if (cGeoLoc != ASIA)
        [_ASRBButton setOn:FALSE animated:TRUE];
    if (cGeoLoc != AUSTRALIA)
        [_AURBButton setOn:FALSE animated:TRUE];
    if (cGeoLoc != EUROPE)
        [_EURBButton setOn:FALSE animated:TRUE];
}

- (void) fnSetButtonStatus: (FnGeoLocation) gLoc {
    [self GglResetButtons : gLoc];
    geoLoc = gLoc;
}

- (IBAction)EURBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    sender.selected = !sender.selected;
    if (sender.selected)
        [self fnSetButtonStatus: EUROPE];
    else
        geoLoc = INIT_LOC;
}

- (IBAction)AURBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    sender.selected = !sender.selected;
    if (sender.selected)
        [self fnSetButtonStatus: AUSTRALIA];
    else
        geoLoc = INIT_LOC;
}

- (IBAction)ASRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    sender.selected = !sender.selected;
    if (sender.selected)
        [self fnSetButtonStatus: ASIA];
    else
        geoLoc = INIT_LOC;
}

- (IBAction)AMRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    sender.selected = !sender.selected;
    if (sender.selected)
        [self fnSetButtonStatus: AMERICA];
    else
        geoLoc = INIT_LOC;
}

- (IBAction)AFRBButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    sender.selected = !sender.selected;
    if (sender.selected)
        [self fnSetButtonStatus: AFRICA];
    else
        geoLoc = INIT_LOC;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"GGL2SST"]){
        SelectServiceType *dctrl = (SelectServiceType*)segue.destinationViewController;
            dctrl.SstGloc = geoLoc;
        [self GglResetDb];
    }
}
- (IBAction)NextButtonPressed:(UIButton *)sender forEvent:(UIEvent *)event {
    if (geoLoc == INIT_LOC) {
        [fn_globals FnShowAlert: self : @"Error" :@"Please select geo location"];
    } else {
        /*
        [self performSegueWithIdentifier:@"GGL2SST" sender:self];
        SelectServiceType * vc = [[SelectServiceType alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
         */
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SelectServiceType"];
        SelectServiceType *dctrl = (SelectServiceType*)vc;
        dctrl.SstGloc = geoLoc;
        [self presentViewController:vc animated:YES completion:nil];
    }
}
@end
