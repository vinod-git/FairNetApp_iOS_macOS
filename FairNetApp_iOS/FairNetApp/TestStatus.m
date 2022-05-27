//
//  TestStatus.m
//  FairNetApp
//
//  Created by Vinod Sarjerao Khandkar on 31/10/20.
//

#import "TestStatus.h"
#import "RunTest.h"
#import "DisplayResults.h"
#import "DrawGraph.h"

@interface TestStatus ()

@end

@implementation TestStatus

#define RUNTIME 180

fn_apps TsApp;
NSMutableArray *TsAppList;
FnGeoLocation TsGloc;
RunTest *rt;
bool downloadDone = FALSE;
double pTime = 0.0;
double cTime = 0.0;
double tDiff = 0.0;
bool drLaunched = FALSE;

-(void) TsGetData {
    //int count = 0;
    //int i;
    TsAppList = self.TsAppList;
    TsApp = self.TsApp;
    TsGloc = self.TsGloc;
    //for (i = 0; i < count; i++)
    //    TsApp = (fn_apps)[TsAppList objectAtIndex: i];
    NSLog(@"Received gloc : %d", TsGloc);
}


- (void) TestProgressBar {
    self.TsTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:YES block:^(NSTimer* _Nonnull timer) {
        static int count = 0;
        count++;
        if (100 >= count) {
            self.TsProgressBar.progress = count/100.0f;
        } else {
            [self.TsTimer invalidate];
            //self.TsTimer = nil;
        }
    }];
}

- (long) TsGetTestRunStatus {
    int i = 0;
    long sdlen = 0;
    if (rt != nil) {
        for (i=0; i < INVALID_APP; i++) {
            if (rt->aDownloader[i] != nil) {
                if (sdlen == 0)
                    sdlen = MAX_DATA;
                AppDlInfo dl = rt->aDownloader[i]->dlInfo;
                long odlen = dl.dlDataLen;
                if (odlen < sdlen) {
                    sdlen = odlen;
                }
            }
        }
    }
    return sdlen;
}

- (void) DrawLine : (double) xStart : (double) xPoint : (double) yStart : (double) yPoint : (double) width : (UIColor*) lColor {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(xStart, yStart)];
    [path addLineToPoint:CGPointMake(xPoint, yPoint)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [lColor CGColor];//[[UIColor lColor] CGColor];
    shapeLayer.lineWidth = width;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    [self.view.layer addSublayer:shapeLayer];
    path = nil;
}

- (double) TsGetRunTimeStatus {
    BOOL isDone = FALSE;
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
    cTime = [timeStampObj doubleValue];
    tDiff = cTime - pTime;
    if (tDiff >= RUNTIME) {
        isDone = TRUE;
    }
    return isDone;
}

- (double) TsGetCurrentTimeDouble {
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
    double cTime = [timeStampObj doubleValue];
    return cTime;
}

- (void) TsShowProgress {
    self.TsProgressBar.progress = 0;
    pTime = [self TsGetCurrentTimeDouble];
    drLaunched = FALSE;
    self.TsTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 repeats:YES block:^(NSTimer* _Nonnull timer) {
        //static int count = 0;
        //count++;
        double tsStatus = 0;
        long sdlen = [self TsGetTestRunStatus];
        if (sdlen > 0) {
            tsStatus = ((sdlen*1.0f)/(MAX_DATA*1.0f));
            //NSLog(@"PB: sdlen = %d, MAX_DATA = %d",sdlen, MAX_DATA);
            //NSLog(@"Progressbar status : %f", tsStatus);
        }
        BOOL isDone = [self TsGetRunTimeStatus];
        if (1.0 > tsStatus && isDone != TRUE) {
            self.TsProgressBar.progress = tsStatus;
            //[self DrawLine:0 :375 :500 :500 :2 :[UIColor blueColor]];
            [dG DrawBarChart: rt : self.view];
        } else {
            self.TsProgressBar.progress = 1;
            downloadDone = TRUE;
            [self.TsTimer invalidate];
            //self.TsTimer = nil;
            if (FALSE == drLaunched)
            {
                //DisplayResults * vc1 = [[DisplayResults alloc] init];
                //[self performSegueWithIdentifier:@"TS2DR" sender:self];
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"DisplayResults"];
                DisplayResults *dctrl = (DisplayResults*)vc;
                dctrl.drRt = rt;
                dctrl.modalPresentationStyle = 0;
                [self presentViewController:vc animated:YES completion:nil];
                [self TsInitDb];
                drLaunched = TRUE;
            }
        }
    }];
}

- (void) TsTest : (RunTest*) rt {
    Downloader* dl;
    while (TRUE) {
        if (rt->aDownloader[0] != nil) {
            dl = rt->aDownloader[0];
            long a = dl->dlInfo.dlDataLen;
            NSLog(@"Received data len = %ld" , a);
        }
    }
}

- (void) TsRunTest : (NSMutableArray*) TsAppList : (fn_apps) TsApp{
    rt = [RunTest alloc];
    [rt RtStart : TsAppList : TsApp : TsGloc : self];
    //[self TsTest : rt];
}

- (void) TsDisplayResultsHandler {
    while (downloadDone == FALSE) {
        // Sleep for 500 ms
        usleep(500000);
    }
    downloadDone = FALSE;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"DisplayResults"];
    DisplayResults *dctrl = (DisplayResults*)vc;
    dctrl.drRt = rt;
    [self presentViewController:vc animated:YES completion:nil];
    [self TsInitDb];
    drLaunched = TRUE;
}

- (void) TsDisplayResultsHandlerThread {
    [self TsDisplayResultsHandler];
}

-(void) TsDisplayResults {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self TsDisplayResultsHandlerThread]; });
    /*
    {
        DisplayResults * vc = [[DisplayResults alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
     */
}

- (void) TsInitDb {
    TsApp = INVALID_APP;
    TsAppList = nil;
    TsGloc = INVALID_LOC;
    rt = nil;
    downloadDone = FALSE;
    //drLaunched = FALSE;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self TsInitDb];
    [self TsGetData];
    [self TsRunTest : TsAppList : TsApp];
    [self TsShowProgress];
    //[self TsDisplayResults];
    //[fn_globals FnShowAlert : self];
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
    if([segue.identifier isEqualToString:@"TS2DR"]){
        DisplayResults *dctrl = (DisplayResults *)segue.destinationViewController;
        dctrl.drRt = rt;
    }
}

@end
