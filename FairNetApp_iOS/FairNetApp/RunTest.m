//
//  RunTest.m
//  FairNetApp
//
//  Created by Vinod Sarjerao Khandkar on 02/11/20.
//

#import <Foundation/Foundation.h>
#import "fn_globals_if.h"
#import "Downloader.h"
#import "TestStatus.h"
#import "RunTest.h"
#import "Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>


@implementation RunTest : NSObject

int count = 0;
ServerInfo servInfo;
NSString *rtHgetReqMap[INVALID_APP];
NSString *rtInitHgetReqMap[INVALID_APP];
struct RtInfoStruct rtInfo;

-(NSString*) RtGetHgetHeaderReq : (fn_apps) cApp {
    NSString* header = nil;
    NSString* rval = nil;
    switch (cApp){
        case HOTSTAR:
            rval = @"Accept:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;.8,application/signed-exchange;v=b3\r\nAccept-Encoding: gzip, deflate, br\r\nAccept-Language:en-US,en;q=0.9\r\nConnection:keep-alive\r\nHost: hses.akamaized.net\r\nUpgrade-Insecure-Requests:1\r\nUser-Agent: Mozilla/5.0(Windows NT 10.0; Win64; x64) AppleWebKit/537.36(KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36\r\n\r\n";
            break;
        case NETFLIX:
            rval = @"Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3\r\nAccept-Encoding: gzip, deflate, br\r\nAccept-Language: en-US,en;q=0.9\r\nConnection: keep-alive\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36\r\n\r\n";
            break;
        case YOUTUBE:
            rval = @"Connection: keep-alive\r\nUser-agent: Mozilla/5.0 (Windows NT 10.0; -) Gecko/20100101 Firefox/66.0\r\nAccept: */*\r\ncache-control: max-age=0\r\nupgrade-insecure-requests: 1\r\n\r\n";
            break;
        case PRIMEVIDEO:
            rval = @"HOST: s3-sin-ww.cf.dash.row.aiv-cdn.net\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3\r\nAccept-Encoding: gzip, deflate, br\r\nAccept-Language: en-US,en;q=0.9\r\nConnection: keep-alive\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36\r\n\r\n";
            break;
        case MXPLAYER:
            rval = @"Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3\r\nAccept-Encoding: gzip, deflate, br\r\nAccept-Language: en-US,en;q=0.9\r\nConnection: keep-alive\r\nHost: media-content.akamaized.net\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36\r\n\r\n";
            break;
        case HUNGAMA:
            rval = @"HOST: hunstream.hungama.com\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3\r\nAccept-Encoding: gzip, deflate, br\r\nAccept-Language: en-US,en;q=0.9\r\nConnection: keep-alive\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36\r\n\r\n";
            break;
        case ZEE5:
            rval = @"HOST: zee5vod.akamaized.net\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3\r\nAccept-Encoding: gzip, deflate, br\r\nAccept-Language: en-US,en;q=0.9\r\nConnection: keep-alive\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36\r\n\r\n";
            break;
        case VOOT:
            rval = @"HOST: vootvideo.akamaized.net\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3\r\nAccept-Encoding: gzip, deflate, br\r\nAccept-Language: en-US,en;q=0.9\r\nConnection: keep-alive\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36\r\n\r\n";
            break;
        case EROSNOW:
            rval = @"HOST: tvshowhls-b.erosnow.com\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3\r\nAccept-Encoding: gzip, deflate, br\r\nAccept-Language: en-US,en;q=0.9\r\nConnection: keep-alive\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36\r\n\r\n";
            break;
        case SONYLIV:
            rval = @"HOST: securetoken.sonyliv.com\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3\r\nAccept-Encoding: gzip, deflate, br\r\nAccept-Language: en-US,en;q=0.9\r\nConnection: keep-alive\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36\r\n\r\n";
            break;
        /* +AUDIO */
        case WYNK:
            rval = @"Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3\\r\\nAccept-Encoding: gzip, deflate, br\\r\\nAccept-Language: en-US,en;q=0.9\\r\\nConnection: keep-alive\\r\\nCookie: _alid_=LEAWeSdl8QO8wBjtOrraWg==; hdntl=exp=1564347548~acl=*%2fsrch_tipsmusic%2fmusic%2f*%2f1467397498%2fsrch_tipsmusic_INT101303504.mp4.csmil*~data=hdntl~hmac=e4c76a2a21addd5930f1da8e522e67b745ba0fe791a07238cbd483fbd97f8c0e\\r\\nHost: desktopsecurehls-vh.akamaihd.net\\r\\nUpgrade-Insecure-Requests: 1\\r\\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36\\r\\n\\r\\n\\";
            break;
        case GAANA_COM:
            rval = @"Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3\\r\\nAccept-Encoding: gzip, deflate, br\\r\\nAccept-Language: en-US,en;q=0.9\\r\\nConnection: keep-alive\\r\\nCookie: _alid_=Q7W4WuFYau4djubYQujGqA==; hdntl=exp=1564350818~acl=%2fi%2fsongs%2f20%2f1855520%2f21250887%2f21250887_64.mp4%2f*~data=hdntl~hmac=eee41ca29a05f75d8f498f5bad222978e9a2cd51cdd6bbc4e3345999a486c219\\r\\nHost: vodhls-vh.akamaihd.net\\r\\nUpgrade-Insecure-Requests: 1\\r\\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36\\r\\n\\r\\n";
            break;
        case SAAVN:
            rval = @"accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3\\r\\naccept-encoding: gzip, deflate, br\\r\\naccept-language: en-US,en;q=0.9\\r\\ncache-control: max-age=2\\r\\nupgrade-insecure-requests: 1\\r\\nuser-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36\\r\\n\\r\\n";
            break;
        case SPOTIFY:
            rval = @"Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3\\r\\nAccept-Encoding: gzip, deflate, br\\r\\nAccept-Language: en-US,en;q=0.9\\r\\nConnection: keep-alive\\r\\nUpgrade-Insecure-Requests: 1\\r\\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36\\r\\n\\r\\n";
            break;
        case PRIMEMUSIC:
            rval = @"Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3\r\nAccept-Encoding: gzip, deflate, br\r\nAccept-Language: en-US,en;q=0.9\r\nConnection: keep-alive\r\nHost: music.amazon.in\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36\r\n\r\n";
            break;
        case GPLAYMUSIC:
            rval = @"HOST: r2---sn-cvh7knez.c.doc-0-0-sj.sj.googleusercontent.com\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3\r\nAccept-Encoding: gzip, deflate, br\r\nAccept-Language: en-US,en;q=0.9\r\nConnection: keep-alive\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36\r\n\r\n";
            break;
        /* -AUDIO */
        case ST:
            rval = @"";
            break;
        case INVALID_APP:
            break;
        default:
            break;
    }
    header = rval;
    rval = nil;
    return header;
}


- (NSString*) RtGetHgetReq : (fn_apps) capp : (NSString*) appInfo : (NSString*) rServer {
    NSString *rval = nil;
    rval = @"GET ";
    if (nil == appInfo && nil == rServer) {
        rval = [rval stringByAppendingString: @"END HTTP/1.1\r\n"];
    } else {
        if (nil != appInfo)
            rval = [rval stringByAppendingString: appInfo];
        rval = [rval stringByAppendingString: @" HTTP/1.1\r\n"];
        if (rServer != nil) {
            rval = [rval stringByAppendingString: @"HOST: "];
            rval = [rval stringByAppendingString: @"\r\n"];
        }
    }
    return rval;
}

- (NSString*) RtGetAppUrl : (fn_apps) cApp {
    NSString *rval = nil;
     switch (cApp){
         case HOTSTAR:
             rval = @"https://www.hotstar.com/";
             break;
         case NETFLIX:
             rval = @"https://www.netflix.com/";
             break;
         case YOUTUBE:
             rval = @"https://www.youtube.com/";
             break;
         case PRIMEVIDEO:
             rval = @"https://www.primevideo.com/";
             break;
         case MXPLAYER:
             rval = @"https://www.mxplayer.in/";
             break;
         case HUNGAMA:
             rval = @"https://www.hungama.com";
             break;
         case ZEE5:
             rval = @"https://www.zee5.com/";
             break;
         case VOOT:
             rval = @"https://www.voot.com/";
             break;
         case EROSNOW:
             rval = @"https://erosnow.com/";
             break;
         case SONYLIV:
             rval = @"https://www.sonyliv.com/";
             break;
         /* +AUDIO */
         case WYNK:
             rval = @"https://wynk.in/music";
             break;
         case GAANA_COM:
             rval = @"https://gaana.com/";
             break;
         case SAAVN:
             rval = @"https://www.jiosaavn.com/";
             break;
         case SPOTIFY:
             rval = @"https://www.spotify.com/";
             break;
         case PRIMEMUSIC:
             rval = @"https://music.amazon.in/";
             break;
         case GPLAYMUSIC:
             rval = @"https://play.google.com/music";
             break;
         /* -AUDIO */
         /* +ST */
         case ST:
             rval = @"STFD";
             break;
         /* -ST */
         case INVALID_APP:
             break;
         default:
             break;
     }
     return rval;
}

- (NSString*) RtGetAppDfile : (fn_apps) cApp {
    NSString *rval = nil;
    switch (cApp){
        case HOTSTAR:
            rval = @"/videos/plus/nzrsp/200_c87ac2ef92/1000234882/1556648252010/5d0f83c3ccbf4501cf952bdfc8c0d785/media-5/segment-1.ts";
            break;
        case NETFLIX:
            rval = @"/range/13799793-16280625?o=AQFGTfl4VAi-FaHnBM9bs9z9Je6awXE04iPZFhE9CTZQKqJ25FaQKei-dTJOv7u34PZV3bTAdMe4yoaha7kXUVfMvR9eD5clp9lOlTaVd__hv7ovp_U6HlvAA5SnkRZS9SeQUK96MYvnp8r70wqh71-4Y9EB0NAXb7X";
            break;
        case YOUTUBE:
            rval = @"/videoplayback?expire=1562904733&ei=PbQnXdHFHOKZ8QOMkaOQDg&ip=2405%3A204%3A2219%3A2a15%3A6557%3Acb58%3A668c%3Af7";
            break;
        case PRIMEVIDEO:
            rval = @"/dm/2$IiZdB0kcptjDslQmssXiOX6FBAc~/a55c/036c/9111/4b7b-b7a7-4371fd71e407/64b9e7f4-97c5-4278-ba1e-b4909715452c_video_11.mp4";
            break;
        case MXPLAYER:
            rval = @"/video/26461dcf57c91948e6ee9fc55c58883e/5/dash/segments/h264_1080_baseline_5800k_11.m4s";
            break;
        case HUNGAMA:
            rval = @"/c/5/c7a/66f/49092553/49092553_1000.mp4_1.m3u8?pF_TqrsNPcNoULokMGEIMx8Pce9b2KAb-ehERlnxp4YQRHpmSe3TMMJ4QvCYYpejc0_";
            break;
        case ZEE5:
            rval = @"/drm1/elemental/dash/ORIGINAL_CONTENT/DOMESTIC/HINDI/RAGNI_MMS_2_UNCENSORD_REVISED/manifest1080p/1080p_000000055.mp4";
            break;
        case VOOT:
            rval = @"/s/enc/hls/p/1982551/sp/198255100/serveFlavor/entryId/0_8mvarek0/v/21/pv/1/ev/42/flavorId/0_5zp612pq/name/a.mp4";
            break;
        case EROSNOW:
            rval = @"/hls/tv/4/1029204/episode/6674642/1248/1029204_6674642_640_360_48_1200_6.ts";
            break;
        case SONYLIV:
            rval = @"/beyhad_2_mahamovie_revised_20200306T181315_1200k_20200306T191848_000000014.mp4?hdntl=exp=1594542606~acl=/";
            break;
        case WYNK:
            rval = @"/i/srch_universalmusic/music/,128,64,32,320,/1548664947/srch_universalmusic_00602577433320-US2BU1900125.mp4.csmil/segment1_0_a.ts?null=0&hdntl=exp=1563056231~acl=*/srch_universalmusic/music/*/1548664947/srch_universalmusic_00602577433320-US2BU1900125.mp4.csmil*~data=hdntl~hmac=37501ae3c3ac2b2cfe3a95e609f3998bc3538842e8f9d505530b7c243d277b2e";
            break;
        case GAANA_COM:
            rval = @"/i/songs/69/2437469/25658817/25658817_64.mp4/segment1_0_a.ts?set-akamai-hls-revision=5&hdntl=exp=1562971199~acl=/i/songs/69/2437469/25658817/25658817_64.mp4/*~data=hdntl~hmac=efff171e28022490f6818a44505eb032fc027ca28bf12d88bcea3b7dafa47490";
            break;
        case SAAVN:
            rval = @"/506/15d49653a626440d5463b0b54ea939fd.mp3?Expires=1563574268&Signature=C7UPEIVaQXLNcgLBVv74btthE5ECTsQLS1ikaIWtiswGMWRCL36P~p70Yx5BDdjUObmOENVHehVR-BEdBg2GyiW0KRcUm81jhb7JO1ZuYSoUha8WbJsfCbudurb3Fgi5qy7Q-12L25OO83ieldnEj1b7WMZPr9F5vF7y4MVXBdB5KaO1S2YWVBEgnF7ydRJIIbo9Epv84l7yKN6Yrb4FKv9uOM7DdRW1hRQ1zuPB6Jm-QrC1s7Zx7zWWiH21DVA~lMKLqGxnK472RBatE9TaNzI-U4BGiepsgHFmkceM1wiX1u1YSVuia~MJCc1-Tpb5i-bGSu3b6hpk~OAVRo77Hg__&Key-Pair-Id=APKAJB334VX63D3WJ5ZQ";
            break;
        case SPOTIFY:
            rval = @"/audio/ec50aef8a65614acfd6d2eabe95b784e2b333b95?1562972269_nEPD3UIfYOEpHvGQymrZ-KDCt3JZeTyUrMDYsVj5IWo";
            break;
        case PRIMEMUSIC:
            rval = @"/746abbd1-4282715717/b43b38f0-bb0f-342f-a513-29850b033e08.m4s?r=b4bcaa20-0cb5-4f31-8a89-92aad824cddf&rs=EU&mt=IN";
            break;
        case GPLAYMUSIC:
            rval = @"/videoplayback?id=9d73b5c19e3d0d94&itag=141&source=skyjam&ei=sioKX8KxGLmJz7sPi7G32A4&o=08526904058750200680&range=4161536-5210111&segment=8&ratebypass=yes&cpn=OJadDSYEfBqW8_RT&ip=0.0.0.0&ipbits=0&expire=1594501969&sparams=ei%2Cexpire%2Cid%2Cip%2Cipbits%2Citag%2Cmh%2Cmip";
            break;
        case INVALID_APP:
            break;
            /* +ST */
        case ST:
            rval = @"STFD";
            break;
            /* -ST */
        default:
            break;
    }
    return rval;
}

Downloader *sDownloader;
Downloader *cnDownloader;
nw_connection_t  conn;
nw_connection_t  cnConn;

- (void) RtStoreServerInfo : (NSString*) aData {
    NSArray *serverInfo = [aData componentsSeparatedByString: @"\r\n"];
    rtInfo.appServer = serverInfo[1];
    rtInfo.port = [serverInfo[2] intValue];
    NSLog(@"Received data : %d", servInfo.port);
    isServerInfoAvailable = TRUE;
}

- (void) RtSendServerInfoRequest {
    NSNumber *nsGAppId = [NSNumber numberWithInt: GLOBAL_APP_ID];
    NSString *gAppId = [fn_globals FnConverNumberToString : nsGAppId];
    NSString *gLoc = [fn_globals FnConverGeoLocEnumToString : rtGloc];
    NSString *rval = [gAppId stringByAppendingString:@":"];
    rval = [rval stringByAppendingString:gLoc];
    [sDownloader DlSendData : rval.UTF8String : [rval length]];
}

- (NSString*) RtFormatCarrierNameRequest {
    NSString* rString = @"IPADDR";
    return rString;
}

- (void) RtSendSCarrierNameRequest : (Downloader*) cDownloader : (NSString*) data {
    [cDownloader DlSendData : data.UTF8String : [data length]];
}

-(void) RtAppDataDownload : (NSString*) aData {
    [self RtReceiveSocketData];
    if (aData == nil) {
        // Send request to webserver
        [self RtSendServerInfoRequest];
    } else {
        if ([aData containsString:@"RUNNING"]) {
            // Store server info
            [self RtStoreServerInfo : aData];
        }
    }
}

- (void) RtStoreCarrierName : (NSString*) aData {
    NSArray *listItems = [aData componentsSeparatedByString:@","];
    NSString *cInfo = listItems[10];
    listItems = [cInfo componentsSeparatedByString:@":"];
    cInfo = listItems[1];
    cInfo = [cInfo stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    carrierName = cInfo;
}

- (void) RtGetCarrierName : (NSString*) aData {
    NSString *bURL = @"http://ip-api.com/json/";
    NSString *fURL = [bURL stringByAppendingString:aData];
    NSURL *url = [NSURL URLWithString:fURL];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        // Print response JSON data in the console.
        NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
        [self RtStoreCarrierName:[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]];
    }];
    [task resume];
}

-(void) RtCarrierNameDownload : (NSString*) aData {
    [self RtReceiveSocketDataCarrierName];
    if (aData == nil) {
        NSString* req = [self RtFormatCarrierNameRequest];
        [cnDownloader DlSendData : req.UTF8String : [req length]];
    } else {
        //[self RtStoreCarrierName : aData];
        [self RtGetCarrierName : aData];
    }
}

-(void) RtProcessSocketError {
    
}

-(void) RtReceiveSocketData {
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
                [self RtReceiveSocketData]; //Perpetuate receive loop for next time
            } else {
                NSLog(@"error in scheduling next receive: %@", receive_error);
                NSString *errorString = (NSString*)receive_error;
                NSLog(@"Error : %@", errorString);
                //usleep(200000);
                //[self DlProcessSocketError];
                if (sDownloader->dlInfo.dlStatus != INVALID_STATUS) {
                    sDownloader->dlInfo.dlStatus = INVALID_STATUS;
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{[self RtProcessSocketError]; });
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
            [self RtAppDataDownload : rec_cast];
        }
        else {
            // No content, so directly schedule the next receive
            schedule_next_receive();
        }
    });
}

-(void) RtReceiveSocketDataCarrierName {
    __block NSString* rec_cast;
    nw_connection_receive(cnDownloader->conn, 1, UINT32_MAX, ^(dispatch_data_t content, nw_content_context_t context, bool is_complete, nw_error_t receive_error) {
        //prepare for next receive
        dispatch_block_t schedule_next_receive = ^{
            if (is_complete &&
                context != NULL && nw_content_context_get_is_final(context)) {
                NSLog(@"final notification received - no more data");
                //exit(0);
            }
            if (receive_error == NULL) {
                [self RtReceiveSocketDataCarrierName]; //Perpetuate receive loop for next time
            } else {
                NSLog(@"error in scheduling next receive: %@", receive_error);
                NSString *errorString = (NSString*)receive_error;
                NSLog(@"Error : %@", errorString);
                if (cnDownloader->dlInfo.dlStatus != INVALID_STATUS) {
                    cnDownloader->dlInfo.dlStatus = INVALID_STATUS;
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{[self RtProcessSocketError]; });
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
            //[self RtAppDataDownload : rec_cast];
            [self RtCarrierNameDownload : rec_cast];
        }
        else {
            // No content, so directly schedule the next receive
            schedule_next_receive();
        }
    });
}


-(void) RtSetupAppEnv : (fn_apps) cApp {
    NSString *header = [self RtGetHgetHeaderReq : cApp];
    NSString *ini_hget_req = [self RtGetHgetReq : cApp : [self RtGetAppUrl : cApp]: nil];
    NSString *hget_req = [self RtGetHgetReq : cApp : [self RtGetAppDfile : cApp]: nil];
    NSString *fin_hget_req = [self RtGetHgetReq : cApp : nil : nil];
    hget_req = [hget_req stringByAppendingString:header];
    rtInfo.rtAppGetFinHgetReq = fin_hget_req;
    rtInfo.rtAppGetHgetReq[cApp] = hget_req;
    rtInfo.rtAppGetInitHgetReq[cApp] = ini_hget_req;
    header = nil;
}

-(void) RtAppServerThread : (UIViewController*) vc {
    NSString *wServer = fn_globals->webServer;
    int  wPort = fn_globals->webServerPort;
    sDownloader = [[Downloader alloc] init];
    while (![sDownloader->sockStatus  isEqual: @"SOCK_EST"]) {
        [sDownloader DlSetupCommChannel : WEB_SERVER : wServer : wPort : nil];
        if ([sDownloader->sockStatus isEqual:@"SOCK_ERROR"]) {
            [fn_globals FnShowAlertFromThread: vc : @"Connection error" : @"Server connection failed : Please check the internet connection"];
            sDownloader->sockStatus = @"SOCK_INVALID";
        }
    }
    conn = sDownloader->conn;
    [self RtAppDataDownload : nil];
    wServer = nil;
}

-(void) RtWiFiCarrierNameHandler {
    NSString *wServer = fn_globals->webServer;
    int  wPort = fn_globals->webServerPort;
    cnDownloader = [[Downloader alloc] init];
    [cnDownloader DlSetupCommChannel : WEB_SERVER : wServer : wPort : nil];
    cnConn = cnDownloader->conn;
    [self RtCarrierNameDownload : nil];
    wServer = nil;
}

- (NSString*) RtGetCellularCarrierName {
    NSString* currCT;
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    // Get Cellular network carrier name
    NSDictionary *ctList = netinfo.serviceCurrentRadioAccessTechnology;
    NSDictionary *cList = netinfo.serviceSubscriberCellularProviders;
    for (NSString *key in ctList) {
        if (ctList[key] != nil )
            currCT = ctList[key];
    }
    CTCarrier* currCarrier = cList[currCT];
    NSString* cName = [currCarrier carrierName];
    currCT = nil;
    netinfo = nil;
    ctList = nil;
    cList = nil;
    currCarrier = nil;
    return cName;
}

- (void) RtCarrierNameThread {
    NSString* cName = @"LOCAL";
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if(status == NotReachable)
    {
        //No internet
    }
    else if (status == ReachableViaWiFi)
    {
        //WiFi
        NSLog(@"WiFi");
        [self RtWiFiCarrierNameHandler];
    }
    else if (status == ReachableViaWWAN)
    {
        carrierName = [self RtGetCellularCarrierName];
    } else {
        carrierName = cName;
    }
    cName = nil;
}

-(void) RtSetupEnv : (NSMutableArray*) rtAppList : (fn_apps) rtApp : (FnGeoLocation) cRtGloc : (UIViewController*) vc {
    int i = 0;
    appList = rtAppList;
    tApp = rtApp;
    rtGloc = cRtGloc;
    for (i=0; i< INVALID_APP; i++) {
        aDownloader[i] = nil;
        //[self RtSetupAppEnv : (fn_apps)i];
    }
    for (NSNumber *item in appList)  {
        [self RtSetupAppEnv : (fn_apps)item.intValue];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self RtAppServerThread : vc]; });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self RtCarrierNameThread]; });
}

-(void) RtSetAdownloader : (int) cApp : (struct RtInfoStruct*) rtInfo : (Downloader*) cDownloader {
    {
        AppRtInfo *appRtInfo = &cDownloader->appRtInfo;
        appRtInfo->cApp = cApp;
        appRtInfo->appServer = rtInfo->appServer;
        appRtInfo->port = rtInfo->port;
        appRtInfo->rtAppGetInitHgetReq = rtInfo->rtAppGetInitHgetReq[cApp];
        appRtInfo->rtAppGetHgetReq = rtInfo->rtAppGetHgetReq[cApp];
        appRtInfo->rtAppGetFinHgetReq = rtInfo->rtAppGetFinHgetReq;
    }
    {
        AppDlInfo *dlInfo = &aDownloader[cApp]->dlInfo;
        dlInfo->dlStatus = INIT;
        dlInfo->dlDataLen = 0;
        dlInfo->dlSegDataLen = 0;
        dlInfo->numCb = 0;
        dlInfo->dStartTime = 0;
    }
    {
        AppDataInfo *aDataInfo = &aDownloader[cApp]->aDataInfo;
        aDataInfo->lval = 0;
        aDataInfo->val = [[NSMutableArray alloc] init];
    }
}

-(void) RtAppHandler : (int) cApp : (struct RtInfoStruct*) rtInfo : (UIViewController*) vc {
    Downloader *cDownloader = [[Downloader alloc] init];
    //[aDownloader insertObject:[[Downloader alloc] init] atIndex:cApp];
    aDownloader[cApp] = cDownloader;
    //[[self Downloader] DlStart : (struct RtInfoStruct*) rtInfo];
    //rtInfo->cApp = cApp;
    [self RtSetAdownloader : cApp : rtInfo : cDownloader];
    [cDownloader DlStart : vc];
}

-(void) RtAppHandlerThread : (struct RtInfoStruct*) rtInfo : (NSNumber*) cApp : (UIViewController*) vc {
    int cAppE = cApp.intValue;
    while (!isServerInfoAvailable)
        usleep(100000);
    [self RtAppHandler : cAppE : rtInfo : vc];
}

-(void) RtStartApps : (NSMutableArray*) tsAppList : (fn_apps) TsApp : (UIViewController*) vc {
    count = 1;
    NSArray *lTsAppList = [tsAppList copy];
    // Get the server information
    //[self RtAppServerThread];
    // Start individual App
    for (NSNumber *item in lTsAppList)  {
        // Start a thread for each App
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self RtAppHandlerThread : &rtInfo : item : vc]; });
    }
}

-(void) RtInit {
    int i = 0;
    count = 0;
    servInfo.AppServer = @"0.0.0.0";
    servInfo.port = 8084;
    rtInfo.cApp = 0;
    rtInfo.appServer = @"0.0.0.0";
    rtInfo.port = 0;
    for (i = 0; i< INVALID_APP; i++)
    {
        rtInfo.rtAppGetHgetReq[i] = nil;
        rtInfo.rtAppGetInitHgetReq[i] = nil;
    }
    rtInfo.rtAppGetFinHgetReq = nil;
    isServerInfoAvailable = FALSE;
    carrierName = @"LOCAL";
}

-(void) RtStart : (NSMutableArray*) rtAppList : (fn_apps) rtApp : (FnGeoLocation) rtGloc : (UIViewController*) vc {
    [self RtInit];
    [self RtSetupEnv : rtAppList : rtApp : rtGloc : vc ];
    [self RtStartApps : rtAppList : rtApp : vc];
}

@end
