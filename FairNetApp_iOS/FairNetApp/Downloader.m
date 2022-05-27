//
//  Downloader.m
//  FairNetApp
//
//  Created by Vinod Sarjerao Khandkar on 02/11/20.
//

#import <Foundation/Foundation.h>
#import "Downloader.h"
#include <netinet/in.h>

@implementation AppDataObj

@synthesize data, time;

@end

@implementation Downloader

+(id) init {
    int i = 0;
    i++;
    return self;
}

-(nw_endpoint_t) DlGetSock : (NSString*) sAddr : (int) sPort : (UIViewController*) vc {
    const char* sAddrC = [sAddr UTF8String];
    NSString *sPortC = [NSString stringWithFormat:@"%d", sPort];
    const char* port = [sPortC UTF8String];
    nw_endpoint_t endpoint = nw_endpoint_create_host(sAddrC, port);
    return endpoint;
}

- (const char*) DlGetSni : (fn_apps) cApp {
    const char* sni = "INVALID";
    switch (cApp){
        case NETFLIX:
            sni = "ipv4-c004-bom001-hathway-isp.1.oca.nflxvideo.net";
            break;
        case YOUTUBE:
            sni = "r2---sn-i5uif5t-cvhl.googlevideo.com";
            break;
        case HOTSTAR:
            sni = "www.hotstar.com";
            break;
        case PRIMEVIDEO:
            sni = "d25xi40x97liuc.cloudfront.net";
            break;
        case MXPLAYER:
            sni = "media-content.akamaized.net";
            break;
        case HUNGAMA:
            sni = "content1.hungama.com";
            break;
        case ZEE5:
            sni = "akamaividz2.zee5.com";
            break;
        case VOOT:
            sni = "vootvideo.akamaized.net";
            break;
        case EROSNOW:
            sni = "tvshowhls-b.erosnow.com";
            break;
        case SONYLIV:
            sni = "securetoken.sonyliv.com";
            break;
        case WYNK:
            sni = "desktopsecurehls-vh.akamaihd.net";
            break;
        case SAAVN:
            sni = "aa.cf.saavncdn.com";
            break;
        case SPOTIFY:
            sni = "audio4-aki-spotify-com.akamaized.net";
            break;
        case GAANA_COM:
            sni = "a10.gaanacdn.com";
            break;
        case PRIMEMUSIC:
            sni = "dfqzuzzcqflbd.cloudfront.net";
            break;
        case GPLAYMUSIC:
            sni = "music-pa.clients6.google.com";
            break;
        default:
            sni = "INVALID";
            break;
    }
    return sni;
}

- (nw_parameters_t) DlGetSockParams : (fn_apps) cApp {
    nw_parameters_configure_protocol_block_t configure_tls =  NW_PARAMETERS_DEFAULT_CONFIGURATION;
    configure_tls = ^(nw_protocol_options_t tls_options) {
        sec_protocol_options_t sec_options = nw_tls_copy_sec_protocol_options(tls_options);
        const char* sni = [self DlGetSni: cApp];
        sec_protocol_options_set_tls_server_name(sec_options, sni);
        sec_protocol_options_set_peer_authentication_required(sec_options, FALSE);
    };
    nw_parameters_configure_protocol_block_t configure_tcp =  NW_PARAMETERS_DEFAULT_CONFIGURATION;
    configure_tcp = ^(nw_protocol_options_t tcp_options) {
        nw_tcp_options_set_no_delay(tcp_options, 0);
    };
    //configure_tls = NW_PARAMETERS_DISABLE_PROTOCOL;
    nw_parameters_t parameters = nw_parameters_create_secure_tcp(
            configure_tls,
            configure_tcp
    );
    return parameters;
}

- (nw_connection_t) DlSockConn : (int) cApp : (nw_endpoint_t) sock : (nw_parameters_t) sockParams {
    nw_connection_t sockConn = nw_connection_create(sock, sockParams);
    // Store connection context
    conn = sockConn;
    return sockConn;
}

- (void) DlSockConnStartPrepare : (nw_connection_t) sockConn {
    NSLog(@"connection logged: %@", [sockConn debugDescription]);
    nw_connection_set_queue(sockConn, dispatch_get_global_queue(QOS_CLASS_UTILITY, 0));
    nw_connection_set_state_changed_handler(sockConn, ^(nw_connection_state_t state, nw_error_t error) {
            if(error) {
                sockStatus = @"SOCK_ERROR";
                NSLog(@"error in starting connection: %@", error);
            }
            else{
                if (state == nw_connection_state_preparing) {
                    NSLog(@"Establishing connection");
                } else if (state == nw_connection_state_waiting) {
                    NSLog(@"connection waiting");
                } else if (state == nw_connection_state_failed) {
                    NSLog(@"connection failed");
                } else if (state == nw_connection_state_ready) {
                    NSLog(@"connected");
                    sockStatus = @"SOCK_EST";
                    //Start listening
                    //aDataInfo *aData = [self DlReceiveSocketData];
                } else if (state == nw_connection_state_cancelled) {
                    NSLog(@"canceled connection");
                }
            }
        });
        
    NSLog(@"connection before starting: %@", sockConn);
}

- (void) DlSockStateChangeHandler : (nw_connection_state_t) state : (nw_error_t) error {
    
}

- (void) DlSockConnStart :  (nw_connection_t) sockConn{
    [self DlSockConnStartPrepare : sockConn];
    nw_connection_start(sockConn);
}

-(nw_connection_t) DlSetupCommChannel : (int) cApp : (NSString*) appServer : (int) port : (UIViewController*) vc {
    if ([sockStatus  isEqual: @"SOCK_INPROCESS"])
        return nil;
    if ([sockStatus  isEqual: @"SOCK_ERROR"])
        return nil;
    // Get socket
    nw_endpoint_t sock = [self DlGetSock : appServer : port : vc];
    sockStatus = @"SOCK_INPROCESS";
    // Get socket parameters
    nw_parameters_t sockParams = [self DlGetSockParams : cApp];
    // Create connection
    nw_connection_t sockConn = [self DlSockConn : cApp: sock : sockParams];
    // Start connection
    [self DlSockConnStart : sockConn];
    return sockConn;
}

-(void) DlSendData : (const char*) data : (long) size {
    //__block nw_error_t error;
    dispatch_queue_t aDataSendQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_data_t content = dispatch_data_create(data, size, aDataSendQueue, DISPATCH_DATA_DESTRUCTOR_DEFAULT);
    nw_connection_send(conn, content, NW_CONNECTION_DEFAULT_MESSAGE_CONTEXT, true, ^(nw_error_t  _Nullable error) {
        if (error != NULL) {
            NSLog(@"error with sending data: %@", error);
        } else {
            //NSLog(@"####### data sent #######");
        }
    });
}


-(void) DlSendHgetReq : (NSString*) cmd : (NSString*) req {
    NSString *aReq;
    long aDataSize;
    aReq = req;
    aDataSize = [aReq length];
    if ([cmd isEqualToString:@"INITIAL"]) {
    } else if ([cmd isEqualToString:@"FINAL"]) {
    } else {
        // Fill speed info
    }
    [self DlSendData : aReq.UTF8String : aDataSize];
}

- (void) DlProcessSocketError {
    if (INVALID_STATUS == dlInfo.dlStatus) {
        dlInfo.numCb += 1;
        [self DlCloseStream : inputStream];
        inputStream = nil;
        [self DlCloseStream : outputStream];
        outputStream = nil;
        dlInfo.dlStatus = INIT;
        // Setup communication channels
        [self DlSetupCommChannel : appRtInfo.cApp : appRtInfo.appServer : appRtInfo.port : nil];
        // Start communication
        usleep(100000);
        [self DlAppDataDownload : nil];
    }
}

-(void) DlReceiveSocketData {
    __block NSString* rec_cast;
    nw_connection_receive(conn, 1, UINT32_MAX, ^(dispatch_data_t content, nw_content_context_t context, bool is_complete, nw_error_t receive_error) {
        //prepare for next receive
        dispatch_block_t schedule_next_receive = ^{
            if (is_complete &&
                context != NULL && nw_content_context_get_is_final(context)) {
                NSLog(@"final notification received - no more data");
                //exit(0);
            }
            if (receive_error == NULL) {
                [self DlReceiveSocketData]; //Perpetuate receive loop for next time
            } else {
                NSLog(@"error in scheduling next receive: %@", receive_error);
                NSString *errorString = (NSString*)receive_error;
                NSLog(@"Error : %@", errorString);
                //usleep(200000);
                //[self DlProcessSocketError];
                if (self->dlInfo.dlStatus != INVALID_STATUS) {
                    self->dlInfo.dlStatus = INVALID_STATUS;
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{[self DlProcessSocketError]; });
                }
                return;
                /*
                if ([errorString rangeOfString:@"reset"].location == NSNotFound) {
                  NSLog(@"receive_error does not contain reset");
                } else {
                  NSLog(@"receive_error contains reset");
                }
                */
            }
        };
        if (content != NULL) {
            schedule_next_receive = [schedule_next_receive copy]; //For next receive
            //Turn received data into string for NSLog
            NSData* nscontent = (NSData*)content;
            const char* received_str = [nscontent bytes];
            rec_cast = [[NSString alloc] initWithBytes:received_str length:[nscontent length] encoding:NSUTF8StringEncoding];
            [self DlAppDataDownload : rec_cast];
        }
        else {
            // No content, so directly schedule the next receive
            schedule_next_receive();
        }
    });
}

-(int) DlReceiveData {
    int lData = 0;
    return lData;
}

- (void)DlCloseStream:(NSStream *)stream {
      [stream close];
      [stream removeFromRunLoop:[NSRunLoop currentRunLoop]
              forMode:NSDefaultRunLoopMode];
      //[stream release];
      stream = nil;
 }

-(void) DlAppDataDownload : (NSString*) aData {
    //int tData  = 0;
    //static int dCount = 0;
    if (dlInfo.dlStatus == INIT) {
        //dlInfo.dlSegDataLen = 0;
        //dlInfo.dlDataLen = 0;
        [self DlReceiveSocketData];
        if (aData != nil) {
            NSLog(@"Received data: %@ for %d", aData, appRtInfo.cApp);
            if ([aData isEqualToString:@"OK"]) {
                dlInfo.dlStatus = DATA;
                [self DlAppDataDownload : nil];
            }
        } else {
            [self DlSendHgetReq : @"INITIAL" : appRtInfo.rtAppGetInitHgetReq];
            NSLog(@"Sent INIT HGET Req for %d", appRtInfo.cApp);
            dlInfo.dStartTime = [[NSDate date] timeIntervalSince1970];
        }
    } else if (dlInfo.dlStatus == DATA) {
        // Send HGET req and wait for data
        [self DlReceiveSocketData];
        if (aData != nil) {
            long dlen;
            dlen = [aData length];
            dlInfo.dlDataLen += dlen;
            dlInfo.dlSegDataLen += dlen;
            NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
            NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
            {
                AppDataObj  *caData = nil;
                while (caData == nil)
                    caData = [[AppDataObj alloc] init];
                //if (caData == nil)
                //    NSLog(@"Nil pointer added");
                caData.data = dlen * 1.0;
                caData.time = [timeStampObj doubleValue];
                [aDataInfo.val addObject:caData];
                aDataInfo.lval += 1;
                //caData = nil;
                //NSLog(@"Data received for %d", appRtInfo.cApp);
            }
            if (dlInfo.dlSegDataLen >= MAX_SEG_DATA) {
                [self DlSendHgetReq : @"NORMAL" : appRtInfo.rtAppGetHgetReq];
                NSLog(@"Sent NORMAL HGET Req for %d", appRtInfo.cApp);
                dlInfo.dlSegDataLen = 0;
                if (dlInfo.dlDataLen >= MAX_DATA) {
                    dlInfo.dlStatus = FIN;
                    [self DlAppDataDownload : nil];
                }
            }
        }
        {
            if (dlInfo.dlSegDataLen == 0) {
                [self DlSendHgetReq : @"NORMAL" : appRtInfo.rtAppGetHgetReq];
                NSLog(@"Sent NORMAL HGET Req for %d", appRtInfo.cApp);
            }
        }
    } else if (dlInfo.dlStatus == FIN) {
        [self DlSendHgetReq : @"END" : appRtInfo.rtAppGetFinHgetReq];
        NSLog(@"Sent FIN HGET Req for %d", appRtInfo.cApp);
        dlInfo.dlStatus = INVALID_STATUS;
        // Sleep for 100 ms and close Socket
        usleep(100000);
        [self DlCloseStream : inputStream];
        inputStream = nil;
        [self DlCloseStream : outputStream];
        outputStream = nil;
    }
}

-(void) DlStart : (UIViewController*) vc {
    NSLog(@"Downloader started for %d", appRtInfo.cApp);
    // Setup communication channels
    sockStatus = @"SOCK_INVALID";
    while (![sockStatus  isEqual: @"SOCK_EST"]) {
        [self DlSetupCommChannel : appRtInfo.cApp : appRtInfo.appServer : appRtInfo.port : vc];
        if ([sockStatus isEqual:@"SOCK_ERROR"]) {
            [fn_globals FnShowAlertFromThread: vc : @"Connection error" : @"Server connection failed : Please check the internet connection"];
            sockStatus = @"SOCK_INVALID";
        }
    }
    // Start communication
    [self DlAppDataDownload : nil];
}

@end
