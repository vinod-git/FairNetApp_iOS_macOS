//
//  Downloader.h
//  FairNetApp
//
//  Created by Vinod Sarjerao Khandkar on 02/11/20.
//

#ifndef Downloader_h
#define Downloader_h

#import "fn_globals_if.h"
#import <Network/Network.h>

@interface Downloader : NSObject {
    NSInputStream *inputStream;
    CFReadStreamRef readStream;
    NSOutputStream *outputStream;
    CFWriteStreamRef writeStream;
@public
    nw_connection_t  conn;
    AppRtInfo        appRtInfo;
    AppDlInfo        dlInfo;
    AppDataInfo      aDataInfo;
    NSString*        sockStatus;
}
//+(id) init;
-(void) DlStart : (UIViewController*) vc ;
-(nw_connection_t) DlSetupCommChannel : (int) cApp : (NSString*) appServer : (int) port : (UIViewController*) vc;
-(void) DlSendData : (const char*) data : (long) size;
@end

@interface AppDataObj : NSObject {
@public
   double data;
   double time;
}
@property(nonatomic, readwrite) double data;
@property(nonatomic, readwrite) double time;
@end
#endif /* Downloader_h */
