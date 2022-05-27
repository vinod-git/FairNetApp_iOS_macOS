//
//  fn_globals_if.m
//  FairNetApp
//
//  Created by Vinod Sarjerao Khandkar on 23/11/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "fn_globals_if.h"

@implementation fn_globals_if : NSObject

-(void) FnInitGlobals : (fn_globals_if*) cfn_globals {
    cfn_globals->cnt = 0;
    cfn_globals->webServer = WEBSERVER;
    cfn_globals->webServerPort = WEBSERVERPORT;
}

-(NSString*) FnConverNumberToString : (NSNumber*) inum {
    NSString* oString;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
    oString = [numberFormatter stringFromNumber:inum];
    return oString;
}

-(NSString*) FnConverGeoLocEnumToString:(FnGeoLocation) ienum {
    NSString *rval = nil;
    switch (ienum) {
        case AFRICA:
            rval = @"AFRICA";
            break;
        case AMERICA:
            rval = @"AMERICA";
            break;
        case ASIA:
            rval = @"ASIA";
            break;
        case AUSTRALIA:
            rval = @"AUSTRALIA";
            break;
        case EUROPE:
            rval = @"EUROPE";
            break;
        case INVALID_LOC:
            rval = @"INVALID_LOC";
            break;
        default:
            rval = @"INVALID_LOC";
            break;
    }
    return rval;
}

-(NSString*) FnConverAppEnumToString:(fn_apps) ienum {
    NSString *rval = nil;
    switch (ienum) {
        case HOTSTAR:
            rval = @"HOTSTAR";
            break;
        case NETFLIX:
            rval = @"NETFLIX";
            break;
        case YOUTUBE:
            rval = @"YOUTUBE";
            break;
        case PRIMEVIDEO:
            rval = @"PRIMEVIDEO";
            break;
        case MXPLAYER:
            rval = @"MXPLAYER";
            break;
        case HUNGAMA:
            rval = @"HUNGAMA";
            break;
        case ZEE5:
            rval = @"ZEE5";
            break;
        case VOOT:
            rval = @"VOOT";
            break;
        case EROSNOW:
            rval = @"EROSNOW";
            break;
        case SONYLIV:
            rval = @"SONYLIV";
            break;
        case WYNK:
            rval = @"WYNK";
            break;
        case GAANA_COM:
            rval = @"GAANA_COM";
            break;
        case SAAVN:
            rval = @"SAAVN";
            break;
        case SPOTIFY:
            rval = @"SPOTIFY";
            break;
        case PRIMEMUSIC:
            rval = @"PRIMEMUSIC";
            break;
        case GPLAYMUSIC:
            rval = @"GPLAYMUSIC";
            break;
        case ST:
            rval = @"ST";
            break;
        case WEB_SERVER:
            rval = @"WEB_SERVER";
            break;
        case REFERENCE_1:
            rval = @"REFERENCE 1";
            break;
        case REFERENCE_2:
            rval = @"REFERENCE 2";
            break;
        case INVALID_APP:
            rval = @"INVALID_APP";
            break;
        default:
            rval = @"INVALID_APP";
            break;
    }
    return rval;
}

- (UILabel*) FnGetUiLabel : (float) xPoint : (float) yPoint : (float) xRange : (float) yRange {
    UILabel *rLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, yPoint, xRange, yRange)];
    [rLabel setTextColor:[UIColor blackColor]];
    [rLabel setBackgroundColor:[UIColor clearColor]];
    [rLabel setFont:[UIFont fontWithName: @"HelveticaNeue-UltraLight" size: 15.0f]];
    return rLabel;
}

- (NSString*) FnGetStringFromDouble : (double) numDouble {
    NSNumber *numNSNum = [NSNumber numberWithDouble:numDouble];
    NSString *numS = [numNSNum stringValue];
    return numS;
}

- (NSString*) FnGetStringFromInt : (int) numInt {
    NSNumber *numNSNum = [NSNumber numberWithInt: numInt];
    NSString *numS = [numNSNum stringValue];
    return numS;
}

- (UIWindow *) FnkeyWindow {
    NSPredicate* filter =
        [NSPredicate predicateWithBlock:^BOOL(UIWindow* window, NSDictionary* bindings) {
            return [window isKeyWindow];
    }];
    
    // Array has windows from all scenes.
    NSArray* windows = [[UIApplication sharedApplication] windows];
    
    // We may have a key window from each existing scene, but the first is the one we want.
    return [[windows filteredArrayUsingPredicate:filter] lastObject];
}


- (void) FnShowAlertFromThread : (UIViewController*) uic : (NSString*) title : (NSString*) mesg {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
            message:mesg
            preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
    defaultAction = [UIAlertAction actionWithTitle:@"CLOSE" style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
        exit(0);
    }];
    [alert addAction:defaultAction];
        [uic presentViewController:alert animated:YES completion:nil];
}

- (void) FnShowAlert : (UIViewController*) uic : (NSString*) title : (NSString*) mesg {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
            message:mesg
            preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
    defaultAction = [UIAlertAction actionWithTitle:@"CLOSE" style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
        exit(0);
    }];
    [alert addAction:defaultAction];
        [uic presentViewController:alert animated:YES completion:nil];
    }) ;
}

- (void) FnSetButton : (UISwitch *)sender {
    [sender setOn:TRUE animated:TRUE];
    sender.selected = YES;
}

- (void) FnResetButton : (UISwitch *)sender {
    [sender setOn:FALSE animated:TRUE];
    sender.selected = NO;
}

- (int) FnGenRandomNumber : (int) iNum : (int) rangeNum {
    int randomNum = arc4random_uniform(rangeNum) + iNum;
    return randomNum;
}

@end
