//
//  DrawGraph.m
//  FairNetApp
//
//  Created by Vinod Sarjerao Khandkar on 13/12/20.
//

#import "DrawGraph.h"
#import "RunTest.h"
#import "TestStatus.h"

//@interface DrawGraph ()

//@end

@implementation DrawGraph

double xStart = 0;
double xEnd = 375;
double yBarCeilingLine = 80;
double yBarBaseLine = 500;
int barStrokeWidth = 10;
int barBaseLineWidth = 2;
int barBannerOffset = 10;
int barBannerHeight = 45;
double maxTh = 7;
double lineChartHeight = 210;
double lineChartWidth = 0.0;
double lineChartXOffset = 50;

RunTest* cRt;

- (double) GetYPoint : (double)  aTh : (double) yRange {
    double yUnit = yRange/maxTh;
    double yHeight = aTh * yUnit;
    double yPoint = (yRange - yHeight) + yBarCeilingLine;
    return yPoint;
}

- (double) GetAYPointLine : (double)  aTh : (double) yRange {
    double yUnit = yRange/maxTh;
    double yHeight = aTh * yUnit;
    double yPoint = (yRange + TH_CHART_Y_OFFSET - yHeight);
    if (yPoint < 300)
        NSLog(@"Wrong y point");
    return yPoint;
}


- (double) GetAxPointLine : (double) dPoint : (double) dRange : (double) axRange {
    double axUnit = axRange/dRange;
    double chPoint = (dPoint * axUnit) + xStart + lineChartXOffset;
    return chPoint;
}

- (double) GetXPoint : (int) aNum {
    double xRange = xEnd - xStart;
    int aCount = 0;
    for (int i=0; i < INVALID_APP; i++) {
        if (cRt != nil && cRt->aDownloader[i] != nil) {
            aCount += 1;
        }
    }
    double xUnit = xRange/(aCount+1);
    return aNum*xUnit;
}

- (double) GetATh : (Downloader*)  cDl {
    double aTh = 0.0;
    AppDlInfo dl = cDl->dlInfo;
    int aDataNum = (int)([cDl->aDataInfo.val count]-1);
    //cDl->aDataInfo.lval - 1;
    AppDataObj *data = [cDl->aDataInfo.val objectAtIndex:aDataNum];
    double aDataStartTime = cDl->dlInfo.dStartTime;
    double aDataCurrentTime = data.time;
    double aDataDuration = aDataCurrentTime - aDataStartTime;
    long aDataLen = dl.dlDataLen * 8;
    aTh = (aDataLen/aDataDuration)/OneMb;
    return aTh;
}

- (UIColor*) GetBarColor : (fn_apps) tApp : (fn_apps) cApp {
    UIColor* lColor = [UIColor redColor];
    if (tApp == cApp)
        lColor = [UIColor blueColor];
    return lColor;
}

- (float) GetBannerXStart : (double) xPoint : (double) xRange {
    float xStart = xPoint - (xRange / 2.0) ;
    return xStart;
}

- (float) GetBannerXRange : (fn_apps) cApp {
    float xRange = 0.0;
    NSString* cAppS = [fn_globals FnConverAppEnumToString : cApp];
    float cAppSLen = cAppS.length;
    xRange = cAppSLen + 10;
    cAppS = nil;
    return xRange;
}

- (UILabel*) GetUiLalbel : (double) xPoint : (double) aTh : (fn_apps) cApp : (double) offset {
    float yPoint = yBarBaseLine + barBannerOffset + offset;
    float xRange = [self GetBannerXRange : cApp];
    float xStart = [self GetBannerXStart : xPoint : xRange];
    float yRange = barBannerHeight;
    UILabel* cUiLabel = [fn_globals FnGetUiLabel : xStart : yPoint : xRange : yRange];
    return cUiLabel;
}

- (NSString*) Get2DecimalDouble : (double) val {
    NSString* retVal;
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    retVal = [fmt stringFromNumber:[NSNumber numberWithDouble:val]];
    return retVal;
}

- (NSString*) GetBarBannerText : (double) aTh : (fn_apps) cApp {
    NSString* barText = @"";
    NSString* cAppS = [fn_globals FnConverAppEnumToString : cApp];
    NSString* aThS = [self Get2DecimalDouble:aTh];//[NSString stringWithFormat:@"%.2f", aTh];
    //NSLog(@"Speed : %0.2f",aTh);
    NSString* aThUnit = @"Mbps";
    barText = [barText stringByAppendingString: cAppS];
    barText = [barText stringByAppendingString: @"\n"];
    barText = [barText stringByAppendingString: aThS];
    barText = [barText stringByAppendingString: @"\n"];
    barText = [barText stringByAppendingString: aThUnit];
    cAppS = nil;
    aThS = nil;
    aThUnit = nil;
    return barText;
}

- (UILabel*) UpdateUILabel : (UIView*) cView : (UILabel*) cUiLabel : (NSString*) text : (double) xPoint {
    CGSize maximumSize = CGSizeMake(300, 9999);
    cUiLabel.font = [UIFont fontWithName: @"HelveticaNeue" size: 10.0f];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(maximumSize.width,CGFLOAT_MAX)
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{NSFontAttributeName: cUiLabel.font}
                        context:nil];
    float yPoint = yBarBaseLine + barBannerOffset;
    float xRange = rect.size.width;
    float xStart = [self GetBannerXStart : xPoint : xRange];
    float yRange = barBannerHeight;
    cUiLabel.frame = CGRectMake(xStart, yPoint, xRange, yRange);
    cUiLabel.adjustsFontSizeToFitWidth = YES;
    cUiLabel.numberOfLines = 3;
    cUiLabel.textAlignment = NSTextAlignmentCenter;
    cUiLabel.text = text;
    return cUiLabel;
}

- (void) DrawBarBanner : (double) xPoint : (fn_apps) cApp : (double) aTh  : (UIView*) cView {
    double offset = 0.0;
    NSString* barText = [self GetBarBannerText : aTh : cApp];
    UILabel* cUiLabel = [self GetUiLalbel: xPoint :aTh :cApp : offset];
    cUiLabel = [self UpdateUILabel: cView : cUiLabel : barText : xPoint];
    [cView addSubview: cUiLabel];
    [cViewList addObject:cUiLabel];
    barText = nil;
    cUiLabel = nil;
}

- (void) ClearPreviousChart {
    for (CAShapeLayer *cShapeLayer in shapeLayerList) {
        [cShapeLayer removeFromSuperlayer];
    }
    for (UILabel *cView in cViewList) {
        [cView removeFromSuperview];
    }
}

- (void) DrawBarChart : (RunTest*) rt : (UIView*) cview{
    int i = 0;
    int aNum = 0;
    cRt = rt;
    fn_apps refApp = REFERENCE_1;
    fn_apps tApp = rt->tApp;
    [self ClearPreviousChart];
    [self SetupBarChart : cview];
    if (rt != nil) {
        for (i=0; i < INVALID_APP; i++) {
            if (rt->aDownloader[i] != nil) {
                double aTh = 0.0;
                double yPoint = 0.0;
                double xPoint = 0.0;
                aNum += 1;
                Downloader*  cDl = rt->aDownloader[i];
                int aDataNum = (int)cDl->aDataInfo.lval;
                fn_apps cApp = cDl->appRtInfo.cApp;
                xPoint = [self GetXPoint : aNum];
                if (1 < aDataNum) {
                    aTh = [self GetATh : cDl];
                    double yRange = yBarBaseLine - yBarCeilingLine;
                    yPoint = [self GetYPoint : aTh : yRange];
                    UIColor* lColor = [self GetBarColor : tApp : cApp];
                    [self DrawBar:xPoint :xPoint : yBarBaseLine :yPoint : lColor : cview];
                    if (tApp == cApp) {
                        [self DrawBarLevelLine:xStart :xEnd : yPoint :yPoint : lColor : cview];
                    } else {
                        cApp = refApp;
                        refApp = REFERENCE_2;
                    }
                    [self DrawBarBanner : xPoint : cApp : aTh : cview];
                    lColor = nil;
                }
            }
        }
    }
}


- (void) DrawBarLevelLine : (double) xStart : (double) xPoint : (double) yStart : (double) yPoint : (UIColor*) lColor : (UIView*) cview {
    int levelBarStrokeWidth = 1;
    [self DrawLine : xStart : xPoint : yStart : yPoint : levelBarStrokeWidth : lColor : cview];
}

- (void) DrawBar : (double) xStart : (double) xPoint : (double) yStart : (double) yPoint : (UIColor*) lColor : (UIView*) cview {
    [self DrawLine : xStart : xPoint : yStart : yPoint : barStrokeWidth : lColor : cview];
}

- (void) SetupBarChart : (UIView*) cview {
    yBarBaseLine = CGRectGetHeight(cview.bounds) - 200;
    double yStart = yBarBaseLine;
    double yEnd = yBarBaseLine;
    double lWidth = barBaseLineWidth;
    xEnd = CGRectGetWidth(cview.bounds);
    UIColor* lColor = [UIColor blackColor];
    [self DrawLine:xStart :xEnd :yStart :yEnd :lWidth :lColor: cview];
    lColor = nil;
}

- (void) DrawLineChart : (RunTest*) rt : (AppTh*) twth : (UIView*) cView : (double) yOffset {
    [self ClearPreviousChart];
    [self SetupLineChart:cView : yOffset ];
    [self DrawLineChartPoints : cRt : twth : cView];
}

- (void) DrawLineChartNew : (RunTest*) rt : (AppTh*) twth : (UIView*) cView : (double) yOffset {
    [self ClearPreviousChart];
    [self SetupLineChart:cView : yOffset ];
    [self DrawLineChartPoints : cRt : twth : cView];
}


- (void) DrawLineChartAppPoints : (int) nTwth : (AppThInfo*) twth : (fn_apps) cApp : (UIView*) cView : (UIColor*) lColor {
    int i = 0;
    double xRange = lineChartWidth;
    double yRange = lineChartHeight;
    double pXPoint = 0.0;
    double pYPoint = 0.0;
    double xPointStart = twth[0].time;
    double xPointEnd = twth[nTwth-1].time;
    double xDataEnd = ( xPointEnd - xPointStart);
    int lWidth = 2;
    if (0 < nTwth) {
        double rtime = twth[0].time;
        for (i=0; i<nTwth; i++) {
            double aTh = twth[i].th/OneMb;
            if (aTh > 7)
                aTh = 7;
            double ctime = twth[i].time - rtime;
            double yPoint = [self GetAYPointLine : aTh : yRange];
            double xPoint = [self GetAxPointLine : ctime : xDataEnd : xRange];
            // Draw line
            //if (yPoint < 300)
            //    break;
            if (pXPoint == 0 && pYPoint == 0) {
                pXPoint = xPoint;
                pYPoint = yPoint;
            }
            [self DrawLine:pXPoint :xPoint :pYPoint :yPoint :lWidth :lColor: cView];
            pXPoint = xPoint;
            pYPoint = yPoint;
        }
    }
}

- (void) DrawLineChartPoints : (RunTest*) rt : (AppTh*) twth : (UIView*) cView {
    int i = 0;
    cRt = rt;
    fn_apps tApp = rt->tApp;
    [self SetupLineChart : cView : 300];
    if (rt != nil) {
        for (i=0; i < INVALID_APP; i++) {
            if (rt->aDownloader[i] != nil) {
                Downloader*  cDl = rt->aDownloader[i];
                fn_apps cApp = cDl->appRtInfo.cApp;
                UIColor* lColor = [self GetBarColor : tApp : cApp];
                [self DrawLineChartAppPoints : twth->appThCount[cApp] : twth->appTh[cApp] : cApp : cView : lColor];
                lColor = nil;
            }
        }
    }
}

- (UILabel*) UpdateTextLabel : (UIView*) cView : (UILabel*) cUiLabel : (NSString*) text : (double) xPoint : (double) yPoint : (int) numLines : (NSString*) fname : (double) fSize {
    CGSize maximumSize = CGSizeMake(300, 9999);
    cUiLabel.font = [UIFont fontWithName: fname size: fSize];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(maximumSize.width,CGFLOAT_MAX)
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{NSFontAttributeName: cUiLabel.font}
                        context:nil];
    float xRange = rect.size.width;
    float yRange = rect.size.height;
    cUiLabel.frame = CGRectMake(xPoint, yPoint, xRange, yRange);
    cUiLabel.adjustsFontSizeToFitWidth = YES;
    cUiLabel.numberOfLines = numLines;
    cUiLabel.textAlignment = NSTextAlignmentCenter;
    cUiLabel.text = text;
    return cUiLabel;
}

- (void) WriteText : (double) xPoint : (double) yPoint : (NSString*) text : (UIView*) cView : (int) nLines : (NSString*) fname : (double) fSize {
    UILabel* cUiLabel = [fn_globals FnGetUiLabel : xPoint : yPoint : 500 : 500 ];
    cUiLabel = [self UpdateTextLabel:cView :cUiLabel :text :xPoint : yPoint : nLines : fname : fSize ];
    [cView addSubview: cUiLabel];
    cUiLabel = nil;
}

- (void) DrawGridLines : (double) xStart : (double) xRange : (double) yStart : (double) yRange : (UIView*) cView {
    int i = 0;
    double lWidth = 0.5;
    UIColor* lColor = [UIColor lightGrayColor];
    double xGridSp = xRange/10;
    double yGridSp = yRange/maxTh;
    int numLines = 1;
    double xPos;
    double yPos;
    xPos = CGRectGetWidth(cView.bounds)/2 - 30;
    yPos = yStart - 30;
    NSString* text = @"Speed (in Mbps)";
    [self WriteText : xPos : yPos : text : cView : numLines : @"HelveticaNeue-Light" : 15];
    for (i=0; i < maxTh; i++) {
        xPos = xStart;
        yPos = yStart + (i*yGridSp);
        [self DrawLine: xPos : xStart+xRange :yPos :yPos :lWidth : lColor: cView];
        xPos = xPos - 15;
        yPos = yPos - 5;
        text = [fn_globals FnGetStringFromDouble : (maxTh - i)];
        [self WriteText : xPos : yPos : text : cView : numLines : @"HelveticaNeue-Light" : 15];
    }
    for (i=0; i< 10; i++) {
        yPos = yStart;
        xPos = xStart + (i*xGridSp);
        [self DrawLine: xPos : xPos :yPos :yStart+yRange :lWidth : lColor: cView];
    }
    xPos = xStart + xRange - 40;
    yPos = yStart+yRange + 5;
    text = @"Time";
    [self WriteText : xPos : yPos : text : cView : numLines : @"HelveticaNeue-Light" : 15];
    lColor = nil;
    text = nil;
}

- (void) SetupLineChart : (UIView*) cView : (double) yOffset {
    yBarBaseLine = CGRectGetHeight(cView.bounds) - TH_CHART_Y_MARGIN;
    double xPos = xStart + lineChartXOffset;
    double yStart = yOffset;
    double yEnd = yOffset + lineChartHeight;
    if (yEnd > yBarBaseLine)
        yEnd = yBarBaseLine;
    double lWidth = barBaseLineWidth;
    double xPosEnd = CGRectGetWidth(cView.bounds) - TH_CHART_X_MARGIN;
    lineChartWidth = xPosEnd - xPos;
    lineChartHeight = yEnd - yStart;
    UIColor* lColor = [UIColor blackColor];
    [self DrawLine:xPos :xPosEnd :yStart :yStart :lWidth :lColor: cView];
    [self DrawLine:xPos :xPosEnd :yEnd :yEnd :lWidth :lColor: cView];
    [self DrawLine:xPos :xPos :yStart :yEnd :lWidth :lColor: cView];
    [self DrawLine:xPosEnd :xPosEnd :yStart :yEnd :lWidth :lColor: cView];
    [self DrawGridLines : xPos : (xPosEnd-xPos) : yStart : (yEnd-yStart) : cView];
    lColor = nil;
}

- (void) DrawLine : (double) xStart : (double) xPoint : (double) yStart : (double) yPoint : (double) width : (UIColor*) lColor : (UIView*) cview{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(xStart, yStart)];
    [path addLineToPoint:CGPointMake(xPoint, yPoint)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [lColor CGColor];//[[UIColor lColor] CGColor];
    shapeLayer.lineWidth = width;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    [cview.layer addSublayer:shapeLayer];
    [shapeLayerList addObject:shapeLayer];
    path = nil;
}

- (void) DrawDashedLine : (double) xStart : (double) xPoint : (double) yStart : (double) yPoint : (double) width : (UIColor*) lColor : (UIView*) cview{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(xStart, yStart)];
    [path addLineToPoint:CGPointMake(xPoint, yPoint)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [lColor CGColor];//[[UIColor lColor] CGColor];
    shapeLayer.lineWidth = width;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:10],
      [NSNumber numberWithInt:5],nil]];
    [cview.layer addSublayer:shapeLayer];
    path = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
