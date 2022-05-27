//
//  SelectServiceType.m
//  FairNetApp
//
//  Created by Vinod Sarjerao Khandkar on 29/10/20.
//

#import "SelectServiceType.h"
#import "GetGeoLocation.h"

@interface SelectServiceType ()

@end

@implementation SelectServiceType
int tcount = 0;
FnGeoLocation sstGloc = INVALID_LOC;

- (void) SstInitDb {
    sstGloc = INVALID_LOC;
}

- (void) SstResetDb {
    sstGloc = INVALID_LOC;
}

- (void) SstGetData {
    sstGloc = _SstGloc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tcount += 1;
    [self SstInitDb];
    [self SstGetData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"VST2SVS"] || [segue.identifier isEqualToString:@"VST2SVS-F"]){
        SelectVideoService *dctrl = (SelectVideoService *)segue.destinationViewController;
        dctrl.newcount = 100;
        dctrl.svsGloc = sstGloc;
    }
    if([segue.identifier isEqualToString:@"AST2SAS"] || [segue.identifier isEqualToString:@"AST2SAS-F"]){
        SelectAudioService *dctrl = (SelectAudioService *)segue.destinationViewController;
        dctrl.sasGloc = sstGloc;
    }
}

- (void) SstSetBackwardData : (GetGeoLocation*) vc {
    vc.gglGeoLoc = sstGloc;
}

- (IBAction)SelectServiceTypeBackButtonPressed:(UIBarButtonItem *)sender {
    GetGeoLocation* vc =[self.storyboard instantiateViewControllerWithIdentifier:@"GetGeoLocation"];
    [self SstSetBackwardData : vc];
    [self SstResetDb];
    [self presentViewController:vc animated:YES completion:nil];
}
@end
