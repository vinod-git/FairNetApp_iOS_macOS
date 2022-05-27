//
//  DisplayResults.m
//  FairNetApp
//
//  Created by Vinod Sarjerao Khandkar on 15/11/20.
//

#import "DisplayResults.h"
#import "GetGeoLocation.h"
#import "DrawGraph.h"
#import "WebKit/WebKit.h"

@interface DisplayResults ()

@end

@implementation DisplayResults

NSTimer *DrTimer;
int DrCount = 0;
NSArray *displayTextarray;
RunTest* drRt;
AppRes   appRes[INVALID_APP];
bool isResultReady = FALSE;
bool isDisplayResultDone = FALSE;
NSString* result = @"";
AppTh      appTwth;
AppTh      appAvgth;
NSString* report;

- (void) DrDisplayResult : (NSString*) displayText {
    [self.resultDisplay setText:displayText];
    //self.resultDisplay.text = displayText;
    self.resultDisplay.textColor = [UIColor blackColor];
    self.resultDisplay.adjustsFontSizeToFitWidth = true;
}

- (void) DrDisplayResultChart : (NSString*) displayText {
    // Display result
    [self DrDisplayResult: displayText];
    // Draw result chart
    //[dG DrawLineChart : drRt : appAvgth : self.view : TH_CHART_Y_OFFSET];
}

- (void) DrDisplayResultsHandlerTimer {
    displayTextarray = [NSArray arrayWithObjects:@"",@"Please wait ...",nil];
    DrTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 repeats:YES block:^(NSTimer* _Nonnull timer) {
        if (isResultReady) {
            // Display results
            if (isDisplayResultDone == FALSE) {
                // Display result
                [self DrDisplayResult: result];
                // Draw result chart
                [dG DrawLineChart : drRt : &appAvgth : self.view : TH_CHART_Y_OFFSET];
                isDisplayResultDone = TRUE;
            }
            // Send report
            /*
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self DrSendReportHandlerThread]; });
             */
            [self DrSendReport];
            isResultReady = FALSE;
            [DrTimer invalidate];
            //break;
        }
        else {
            if (DrCount == 0) {
                DrCount = 1;
            } else {
                DrCount = 0;
            }
            //[self DrDisplayResult : displayTextarray[DrCount]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self DrDisplayResult : displayTextarray[DrCount]]; });
        }
    }];
}


- (void) DrDisplayResultsHandler {
    NSArray *displayTextarray = [NSArray arrayWithObjects:@"",@"Please wait ...",nil];
    int count = 0;
    while (true) {
        if (isResultReady) {
            // Display results
            if (isDisplayResultDone == FALSE) {
                dispatch_async(dispatch_get_main_queue(), ^{
                [self DrDisplayResultChart : result]; });
                isDisplayResultDone = TRUE;
            }
            // Send report
            /*
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self DrSendReportHandlerThread]; });
             */
            isResultReady = FALSE;
            break;
        }
        else {
            if (count == 0) {
                count = 1;
            } else {
                count = 0;
            }
            /*
            dispatch_async(dispatch_get_main_queue(), ^{
            [self DrDisplayResultChart : result]; });
             */
            dispatch_async(dispatch_get_main_queue(), ^{
                [self DrDisplayResult : displayTextarray[count]]; });
            [NSThread sleepForTimeInterval:1.0f];
        }
    }
}

- (void) DrDrawResultChartHandler {
    while (!isResultReady)
        usleep(500000);
    [dG DrawLineChart : drRt : &appAvgth : self.view : TH_CHART_Y_OFFSET];
    //[dG DrawLineChart : drRt : &appTwth : self.view : TH_CHART_Y_OFFSET];
}

- (void) DrSendReport {
    Downloader *repDl = [[Downloader alloc] init];
    long dSize = [report length];
    [repDl DlSetupCommChannel : REPORT : WEBSERVER : WEBSERVERPORT : nil];
    [repDl DlSendData: report.UTF8String :dSize];
}

- (void) DrSendReportHandler {
    while (!isResultReady)
        usleep(500000);
    [self DrSendReport];
}


- (void) DrSendReportHandlerThread {
    [self DrSendReportHandler];
}

- (void) DrDisplayResultsHandlerThread {
    [self DrDisplayResultsHandler];
}

- (void) DrDrawResultsHandlerThread {
    [self DrDrawResultChartHandler];
}

- (void) DrInitAppTh : (AppThInfo*) cAppTh {
    int i;
    for (i=0; i< MAX_NUM_DATA_POINTS; i++) {
        cAppTh[i].th = 0.0;
        cAppTh[i].time = 0.0;
    }
}

- (void) DrInitDb {
    int i = 0;
    isResultReady = FALSE;
    result = @"";
    drRt = nil;
    report = @"REPORT\n";
    for (i = 0; i< INVALID_APP; i++) {
        appRes[i].nlow = 0;
        appRes[i].nsame = 0;
        appTwth.appThCount[i] = 0;
        [self DrInitAppTh : appTwth.appTh[i]];
        appAvgth.appThCount[i] = 0;
        [self DrInitAppTh : appAvgth.appTh[i]];
    }
}

- (void) DrGetData {
    drRt = _drRt;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isResultReady = FALSE;
    isDisplayResultDone = FALSE;
    [self DrGetData];
    //[self DrStart: drRt];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self DrStartHandlerThread]; });
    [self DrDisplayResultsHandlerTimer];
    //[self DrDrawResultChartHandler];
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self DrDisplayResultsHandlerThread]; });
     */
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        [self DrDisplayResultsHandlerThread]; });
     */
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self DrDrawResultsHandlerThread]; });
     */
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self DrSendReportHandlerThread]; });
     */
}

- (int) DrGetPartialDownloadApps {
    int i;
    int aCount = 0;
    for (i=0; i< INVALID_APP; i++) {
        if (drRt->aDownloader[i] != nil) {
            long dlen = drRt->aDownloader[i]->dlInfo.dlDataLen;
            if (MAX_DATA > dlen)
                aCount += 1;
        }
    }
    return aCount;
}

- (int) DrGetTotalNumApps {
    int i;
    int aCount = 0;
    for (i=0; i< INVALID_APP; i++) {
        if (drRt->aDownloader[i] != nil) {
            aCount += 1;
        }
    }
    return aCount;
}

- (NSString*) DrFormatAvgThResultString : (int) cApp : (double) avgTh {
    NSString *res;
    NSString *cAppS = [fn_globals FnConverAppEnumToString : cApp];
    res = [cAppS stringByAppendingString:@" : "];
    NSNumber *avgThNum = [NSNumber numberWithDouble:avgTh];
    NSString *avgThS = [avgThNum stringValue];
    res = [res stringByAppendingString:avgThS];
    return res;
}

- (void) DrGetTh : (int) cApp : (AppDataInfo*) aData : (double) stime : (double) etime : (double) mSlotTime {
    int i;
    int twcount = 0;
    double maxSlotTime = mSlotTime;
    double dtime = 0;
    double rtime = 0;
    double dTh = 0;
    double datas = 0;
    if (aData->val == nil)
        return;
    long lval = [aData->val count];
    AppThInfo  *cAppThInfo;
    AppTh      *cAppTh;
    if (0 == mSlotTime) {
        cAppTh = &appAvgth;
        cAppThInfo = cAppTh->appTh[cApp];
    }
    else {
        cAppTh = &appTwth;
        cAppThInfo = cAppTh->appTh[cApp];
    }
    for (i=0; i < lval; i++) {
        AppDataObj *data = [aData->val objectAtIndex:i];
        if (nil == data)
            continue;
        dtime = data->time;
        if (dtime < stime || dtime > etime) {
            continue;
        }
        if ((i == 0) || (rtime == 0) || (dtime == rtime)) {
            rtime = dtime;
            dTh = 0;
        } else {
            if (dtime != 0) {
                double etime = dtime - rtime;
                if (etime < maxSlotTime) {
                    datas += data->data;
                    continue;
                }
                if (0 == maxSlotTime) {
                    datas += data->data;
                    dTh = (double) (datas*8)/(etime);
                } else {
                    dTh = (double) (datas*8)/(etime);
                    rtime = dtime;
                    datas = 0;
                }
            }
        }
        {
            AppThInfo aTh;
            aTh.th = dTh;
            aTh.time = dtime;
            cAppThInfo[twcount] = aTh;
            twcount++;
        }
    }
    cAppTh->appThCount[cApp] = twcount;
  }

- (double) DrGetStartTime {
    NSMutableArray *appList = drRt->appList;
    double rtime = 0.0;
    int sApp = INVALID_APP;
    for (NSNumber *item in appList) {
        int cApp = item.intValue;
        Downloader *cDownloader = drRt->aDownloader[cApp];
        if (nil != cDownloader) {
            AppDataInfo *aData = &cDownloader->aDataInfo;
            if (nil == aData)
                continue;
            if (rtime == 0) {
                AppDataObj *data = [aData->val objectAtIndex:0];
                rtime = data->time;
            } else {
                int i;
                long lval = [aData->val count];//aData->lval;
                for (i = 0; i< (int)lval; i++) {
                    AppDataObj *data = [aData->val objectAtIndex:i];
                    if (nil == data)
                        continue;
                    double ctime = data->time;
                    if (ctime >= rtime) {
                        rtime = ctime;
                        sApp = cApp;
                        break;
                    }
                }
            }
        }
    }
    NSLog(@"Start time = %f for %d", rtime, sApp);
    return rtime;
}

- (double) DrGetEndTime {
    NSMutableArray *appList = drRt->appList;
    double rtime = 0.0;
    int eApp = INVALID_APP;
    for (NSNumber *item in appList) {
        int cApp = item.intValue;
        Downloader *cDownloader = drRt->aDownloader[cApp];
        if (nil != cDownloader) {
            AppDataInfo *aData = &cDownloader->aDataInfo;
            long lval = [aData->val count];//aData->lval;
            if (rtime == 0) {
                NSLog(@"Current App : %d : %ld",cApp, lval-1);
                AppDataObj *data = [aData->val objectAtIndex:lval-1];
                rtime = data->time;
            } else {
                int i;
                long lval = [aData->val count];//aData->lval;
                for (i = (int)lval-1; i >= 0; i--) {
                    AppDataObj *data = [aData->val objectAtIndex:i];
                    if (nil == data)
                        continue;
                    double ctime = data->time;
                    if (ctime <= rtime) {
                        rtime = ctime;
                        eApp = cApp;
                        break;
                    }
                }
            }
        }
    }
    NSLog(@"End time = %f for %d",rtime, eApp);
    return rtime;
}

- (void) DrFillTwth : (AppDataInfo*) aData {
    int i =0;
    long lval = [aData->val count];
    for (i = 0; i < lval; i++) {
        AppDataObj *data = [aData->val objectAtIndex:i];
        if (nil != data) {
            NSString* indexS = [fn_globals FnGetStringFromInt: i];
            NSString* timeS = [fn_globals FnGetStringFromDouble: (data->time)/OneTb];
            NSString* dataS = [fn_globals FnGetStringFromDouble: data->data];
            [self DrFillReport:indexS];
            [self DrFillReport:@":"];
            [self DrFillReport: timeS];
            [self DrFillReport: @":"];
            [self DrFillReport: dataS];
            [self DrFillReport: @"\n"];
        }
    }
}

- (void) DrGenerateTh :  (RunTest*) crt : (double) stime : (double) etime : (double) mSlotTime {
    NSMutableArray *appList = crt->appList;
    double tdiff = etime -stime;
    NSLog(@"Total Time = %f", tdiff);
    for (NSNumber *item in appList) {
        int cApp = item.intValue;
        Downloader *cDownloader = drRt->aDownloader[cApp];
        if (cDownloader == nil)
            continue;
        AppDataInfo *aData = &cDownloader->aDataInfo;
        if (aData == nil)
            continue;
        [self DrGetTh : cApp : aData : stime : etime : mSlotTime];
        if (0 == mSlotTime) {
            int aThCount = appAvgth.appThCount[cApp];
            double aTh = appAvgth.appTh[cApp][aThCount-1].th;
            NSString* res = [self DrFormatAvgThResultString : cApp : aTh/1000000];
            //result = [result stringByAppendingString:res];
            //result = [result stringByAppendingString:@" Mbps\n"];
        } else {
            [self DrFillReport:@"App: "];
            [self DrFillReport:[fn_globals FnConverAppEnumToString : cApp]];
            [self DrFillReport:@"\n"];
            [self DrFillTwth : &cDownloader->aDataInfo];
        }
        NSLog(@"%@", result);
    }
}

- (int) DrGetAppSlotStatus : (int) cApp {
    int i = 0;
    int nlow = 0;
    int ntwth = appTwth.appThCount[cApp];
    NSMutableArray *appList = drRt->appList;
    for (i=0; i < ntwth; i++) {
        double hth = 0;
        double tth = 0;
        for (NSNumber *item in appList) {
            int cApp = item.intValue;
            double cth = appTwth.appTh[cApp][i].th;
            if (cApp == drRt->tApp) {
                tth = cth;
            }
            if (cth > hth) {
                hth = cth;
            }
        }
        if (hth - tth > 1) {
            nlow++;
        }
    }
    return nlow;
}

- (int) DrGetSamePerfStatus {
    NSMutableArray *appList = drRt->appList;
    int nSame = 0;
    int tAppLow  = appRes[drRt->tApp].nlow;
    for (NSNumber *item in appList) {
        int cApp = item.intValue;
        int cAppLow = appRes[cApp].nlow;
        if (tAppLow - 2 < cAppLow && cAppLow < tAppLow + 2)
            nSame++;
    }
    return nSame;
}

- (void) DrGetSlotStatus {
    NSMutableArray *appList = drRt->appList;
    for (NSNumber *item in appList) {
        int cApp = item.intValue;
        appRes[cApp].nlow = [self DrGetAppSlotStatus : cApp];
        appRes[drRt->tApp].nsame = 0;
    }
    appRes[drRt->tApp].nsame = [self DrGetSamePerfStatus];
}

- (bool) DrDetectTdThr {
    bool result = FALSE;
    double sl = 0.6;
    double hl = 0.8;
    int nLow = appRes[drRt->tApp].nlow;
    int nSame = appRes[drRt->tApp].nsame;
    int ntwth = appTwth.appThCount[drRt->tApp];
    if (nLow >= 0.8 * ntwth)
        result = true;
    else if (nLow >= sl* ntwth && nLow < hl * ntwth) {
        if (nSame >= 1)
            result = false;
        else
            result = true;
    } else
        result = false;
    return result;
}

- (bool) DrGetTdThr {
    bool tdThr = FALSE;
    [self DrGetSlotStatus];
    tdThr = [self DrDetectTdThr];
    return tdThr;
}

- (bool) DrGetTdCs {
    bool tdCs = FALSE;
    Downloader *cDownloader = drRt->aDownloader[drRt->tApp];
    if (cDownloader == nil)
        return tdCs;
    int numCb = cDownloader->dlInfo.numCb;
    if (MAX_NUM_CBS <= numCb)
        tdCs = TRUE;
    return tdCs;
}

- (NSString*) DrGetTdStatus : (bool) tdThr : (bool) tdCs {
    NSString *result = @" Traffic differentiation : Not detected";
    NSString *resultMap[2];
    resultMap[0] = @" Traffic differentiation : Not detected";
    resultMap[1] = @" Traffic differentiation : Detected";
    if (tdThr) {
        result = resultMap [tdThr ? 1 : 0];
    }
    if (!tdThr && tdCs) {
        long dlen = drRt->aDownloader[drRt->tApp]->dlInfo.dlDataLen;
        if (MAX_DATA <= dlen) {
            result = resultMap [tdCs ? 1 : 0];
        } else {
            result = resultMap [tdThr ? 1 : 0];
        }
    }
    return result;
}

- (void) DrFillReport : (NSString*) data {
    report = [report stringByAppendingString:data];
}

- (NSString*) DrGetCurrentString {
    NSDate *currentDate = [[NSDate alloc] init];
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    // or Timezone with specific name like
    // [NSTimeZone timeZoneWithName:@"Europe/Riga"] (see link below)
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:timeZone];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssZZZZZ"];
    NSString *localDateString = [dateFormatter stringFromDate:currentDate];
    localDateString = [localDateString stringByReplacingOccurrencesOfString:@":" withString:@""];
    return localDateString;
}

- (NSString*) DrGetCountryCode {
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    return countryCode;
}

- (void) DrFillReportInstanceClientId {
    NSString * uuidS =  [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *instnaceIDS = [self DrGetCurrentString];
    NSString* carrierS = [self DrGetCarrierName];
    NSString* countryCode = [self DrGetCountryCode];
    //[NSString stringWithFormat:@"%f", instnaceID];
    [self DrFillReport : @"Instance:"];
    [self DrFillReport:instnaceIDS];
    [self DrFillReport:@":"];
    [self DrFillReport: carrierS];
    [self DrFillReport:@":"];
    [self DrFillReport:countryCode];
    [self DrFillReport:@"\n"];
    [self DrFillReport : @"ClientId:"];
    [self DrFillReport:uuidS];
}

- (NSString*) DrGetCarrierName {
    NSString* rString = drRt->carrierName;
    return rString;
}

- (void) DrGenerateTrdiffStatus : (RunTest*) crt {
    int taCount, paCount;
    bool tdThr, tdCs;
    NSLog(@"Showing results ....");
    taCount = [self DrGetTotalNumApps];
    paCount = [self DrGetPartialDownloadApps];
    if (paCount == taCount) {
        result = @"Network speed too bad for measurement";
    } else {
        tdThr = [self DrGetTdThr];
        tdCs = [self DrGetTdCs];
        int aThCount = appAvgth.appThCount[crt->tApp];
        double aTh = appAvgth.appTh[crt->tApp][aThCount-1].th/1000000.0;
        NSNumber *avgThNum = [NSNumber numberWithDouble:aTh];
        NSString *avgThS = [avgThNum stringValue];
        NSString *tdResult = [self DrGetTdStatus : tdThr : tdCs];
        NSString *cAppS = [fn_globals FnConverAppEnumToString : crt->tApp];
        //NSString *app = [NSString stringWithFormat:@"  %i", crt->tApp];
        result = [result stringByAppendingString:@"\n"];
        result = [result stringByAppendingString:@" ISP:"];
        result = [result stringByAppendingString:drRt->carrierName];
        result = [result stringByAppendingString:@"\n\n"];
        result = [result stringByAppendingString:@" Service : "];
        result = [result stringByAppendingString: cAppS];
        result = [result stringByAppendingString:@"\n"];
        result = [result stringByAppendingString:@" Average speed : "];
        result = [result stringByAppendingString:avgThS];
        result = [result stringByAppendingString:@" Mbps"];
        result = [result stringByAppendingString:@"\n"];
        result = [result stringByAppendingString:tdResult];
        NSLog(@"TD Status : %@", result);
        [self DrFillReportInstanceClientId];
    }
    isResultReady = TRUE;
}

- (void) DrGenerateMetrics : (RunTest*) crt {
    double stime = [self DrGetStartTime];
    double etime = [self DrGetEndTime];
    [self DrGenerateTh : crt : stime : etime : MIN_SLOT_TIME];
    [self DrGenerateTh : crt : stime : etime : MAX_SLOT_TIME];
}

-(void) DrStart : (RunTest*) crt {
    tString = @"Test";
    [self DrInitDb];
    drRt = crt;
    [self DrGenerateMetrics : crt];
    [self DrGenerateTrdiffStatus : crt];
}

- (void) DrStartHandlerThread {
    [self DrStart: drRt];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)TDDetectionDescription:(UIButton *)sender forEvent:(UIEvent *)event {
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration];
    webView.navigationDelegate = self;

    NSURL *targetURL = [NSURL URLWithString:@"https://www.ieor.iitb.ac.in/files/fairnet_td_detect.pdf"];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [webView loadRequest:request];

    [self.view addSubview:webView];
}

- (IBAction)DisplayResultBackPressed:(UIBarButtonItem *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GetGeoLocation* vc =[sb instantiateViewControllerWithIdentifier:@"GetGeoLocation"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:nil];
}
@end
