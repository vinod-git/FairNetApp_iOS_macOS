//
//  SelectServiceType.h
//  FairNetApp
//
//  Created by Vinod Sarjerao Khandkar on 29/10/20.
//

#import <UIKit/UIKit.h>

#import "fn_globals_if.h"
#import "SelectVideoService.h"
#import "SelectAudioService.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectServiceType : UIViewController
@property (nonatomic, assign) FnGeoLocation SstGloc;
-(IBAction)SelectServiceTypeBackButtonPressed:(UIBarButtonItem *)sender;
@end

NS_ASSUME_NONNULL_END
