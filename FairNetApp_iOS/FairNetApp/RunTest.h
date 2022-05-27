//
//  RunTest.h
//  FairNetApp
//
//  Created by Vinod Sarjerao Khandkar on 02/11/20.
//

#ifndef RunTest_h
#define RunTest_h


#import "Downloader.h"

@interface RunTest : NSObject {
@public
    int  tApp;
    NSMutableArray *appList;
    Downloader *aDownloader[INVALID_APP];
    FnGeoLocation rtGloc;
    bool isServerInfoAvailable;
    NSString* carrierName;
}
-(void) RtStart : (NSMutableArray*) TsAppList : (fn_apps) TsApp : (FnGeoLocation) TsGloc : (UIViewController*) vc;

//@property NSMutableArray *aDownloader; //of type Downloader
//@property (struct RtInfoStruct*) rtInfo1;
//@property bool isServerInfoAvailable;
@end

#endif /* RunTest_h */
