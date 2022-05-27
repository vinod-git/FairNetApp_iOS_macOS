//
//  fn_globals_if.h
//  FairNetApp
//
//  Created by Vinod Sarjerao Khandkar on 29/10/20.
//

#ifndef fn_globals_if_h
#define fn_globals_if_h

#import <UIKit/UIKit.h>

#define MAX_SEG_DATA 625000
#define MAX_DATA 625000*32
#define MIN_SLOT_TIME 0
#define MAX_SLOT_TIME 1.75
#define MAX_NUM_CBS 5
#define GLOBAL_APP_ID 0xFFFFFF
#define WEBSERVER @"127.0.0.1"
//#define WEBSERVER @"s3.ieor.iitb.ac.in"
//#define WEBSERVER @"192.168.0.14"
#define WEBSERVERPORT 8084
#define MAX_NUM_DATA_POINTS 10000
#define TH_CHART_Y_OFFSET 300
#define TH_CHART_Y_MARGIN 100
#define TH_CHART_X_MARGIN 25
#define OneMb 1000000.0
#define OneTb 1000000000
#define MAX_OTH_SERV 2

extern NSString  *webServer ;//@"s3.ieor.iitb.ac.in";
extern int webServerPort;

typedef enum fn_apps_enum {
    INIT_APP = 0,
    MIN_VID_SERVICE_APP,
    HOTSTAR = MIN_VID_SERVICE_APP,
    NETFLIX,
    YOUTUBE,
    PRIMEVIDEO,
    MXPLAYER,
    HUNGAMA,
    ZEE5,
    VOOT,
    EROSNOW,
    SONYLIV,
    MAX_VID_SERVICE_APP = SONYLIV,
    MIN_AUD_SERVICE_APP,
    WYNK = MIN_AUD_SERVICE_APP,
    GAANA_COM,
    SAAVN,
    SPOTIFY,
    PRIMEMUSIC,
    GPLAYMUSIC,
    MAX_AUD_SERVICE_APP = GPLAYMUSIC,
    ST,
    WEB_SERVER,
    REPORT,
    REFERENCE_1,
    REFERENCE_2,
    INVALID_APP
} fn_apps;

typedef enum FnGeoLocationEnum {
    INIT_LOC = 0,
    AFRICA,
    AMERICA,
    ASIA,
    AUSTRALIA,
    EUROPE,
    INVALID_LOC
} FnGeoLocation;

typedef enum fnDlStatusEnum {
    INIT = 0,
    DATA,
    FIN,
    INVALID_STATUS
} fnDlStatus;

typedef struct FnServerInfo {
    NSString *AppServer;
    int port;
} ServerInfo;

typedef struct RtInfoStruct {
    NSString* rtAppGetHgetReq[INVALID_APP];
    NSString* rtAppGetInitHgetReq[INVALID_APP];
    NSString* rtAppGetFinHgetReq;
    NSString* appServer;
    int       port;
    int       cApp;
} RtInfo;

typedef struct AppRtInfoStruct {
    NSString* rtAppGetHgetReq;
    NSString* rtAppGetInitHgetReq;
    NSString* rtAppGetFinHgetReq;
    NSString* appServer;
    int       port;
    int       cApp;
} AppRtInfo;

typedef struct AppDlInfoStruct {
    fnDlStatus dlStatus;
    long dlSegDataLen;
    long dlDataLen;
    int numCb;
    NSTimeInterval dStartTime;
} AppDlInfo;

typedef struct AppDataStruct {
    long size;
    double time;
} AppData;

typedef struct AppDataInfoStruct {
    int               lval;
    NSMutableArray*   val;
} AppDataInfo;

typedef struct AppThInfoStruct {
    long th;
    double time;
} AppThInfo;


typedef struct AppThStruct {
    AppThInfo  appTh[INVALID_APP][MAX_NUM_DATA_POINTS];
    int        appThCount[INVALID_APP];
} AppTh;

typedef struct DlInfoStruct {
    bool      appList[INVALID_APP];
    AppDlInfo appDlInfo[INVALID_APP];
    NSMutableArray *appData[INVALID_APP];
} DlInfo;

typedef struct AppResStruct {
    int nlow;
    int nsame;
} AppRes;

@interface fn_globals_if : NSObject {
@public
    int cnt;
    NSString  *webServer;
    int webServerPort;
}
-(void) FnInitGlobals : (fn_globals_if*) cfn_globals;
-(NSString*) FnConverNumberToString : (NSNumber*) inum;
-(NSString*) FnConverGeoLocEnumToString: (FnGeoLocation) ienum;
-(NSString*) FnConverAppEnumToString:(fn_apps) ienum;
- (UILabel*) FnGetUiLabel : (float) xPoint : (float) yPoint : (float) xRange : (float) yRange;
- (NSString*) FnGetStringFromDouble : (double) numDouble;
- (NSString*) FnGetStringFromInt : (int) numInt;
- (void) FnShowAlertFromThread : (UIViewController*) uic : (NSString*) title : (NSString*) mesg;
- (void) FnShowAlert : (UIViewController*) uic : (NSString*) title : (NSString*) mesg;
- (void) FnSetButton : (UISwitch *)sender;
- (void) FnResetButton : (UISwitch *)sender;
- (int) FnGenRandomNumber : (int) iNum : (int) rangeNum;
@end

extern fn_globals_if *fn_globals;

#endif /* fn_globals_if_h */
