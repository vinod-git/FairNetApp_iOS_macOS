//
//  DisplayResults.h
//  FairNetApp
//
//  Created by Vinod Sarjerao Khandkar on 16/11/20.
//

#import <UIKit/UIKit.h>
#import "RunTest.h"

NS_ASSUME_NONNULL_BEGIN

@interface DisplayResults : UIViewController {
    @public
    //AppThInfo  appTh[INVALID_APP][1000];
    //int        appThCount[INVALID_APP];
    //AppTh      appTwth;
    //AppTh      appAvgth;
    NSString*  tString;
}

-(void) DrStart : (RunTest*) rt;
@property (strong, nonatomic) IBOutlet UIView *DisplayResultsView;
@property (weak, nonatomic) IBOutlet UITextField *displayresults_results;
@property (weak, nonatomic) IBOutlet UILabel *resultDisplay;
@property (nonatomic, assign) RunTest *drRt;
- (IBAction)DisplayResultBackPressed:(UIBarButtonItem *)sender;
- (IBAction)TDDetectionDescription:(UIButton *)sender forEvent:(UIEvent *)event;

@end

NS_ASSUME_NONNULL_END
