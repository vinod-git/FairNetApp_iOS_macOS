//
//  TestStatus.h
//  FairNetApp
//
//  Created by Vinod Sarjerao Khandkar on 31/10/20.
//

#import <UIKit/UIKit.h>
#import "fn_globals_if.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestStatus : UIViewController
@property (nonatomic, retain) NSMutableArray *TsAppList;
@property (nonatomic, assign) fn_apps TsApp;
@property (nonatomic, assign) FnGeoLocation TsGloc;
@property (weak, nonatomic) IBOutlet UIProgressView *TsProgressBar;
@property NSTimer *TsTimer;
@end

NS_ASSUME_NONNULL_END
