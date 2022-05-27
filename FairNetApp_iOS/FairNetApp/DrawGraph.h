//
//  DrawGraph.h
//  FairNetApp
//
//  Created by Vinod Sarjerao Khandkar on 13/12/20.
//

#import <UIKit/UIKit.h>
#import "RunTest.h"

NS_ASSUME_NONNULL_BEGIN

@interface DrawGraph : UIViewController {
    @public
    NSMutableArray*   shapeLayerList;
    NSMutableArray*   cViewList;
}
- (void) DrawBarChart : (RunTest*) rt : (UIView*) cview;
- (void) DrawLineChart : (RunTest*) rt : (AppTh*) twth : (UIView*) cView : (double) yOffset;
- (void) DrawLineChartNew : (RunTest*) rt : (AppTh*) twth : (UIView*) cView : (double) yOffset;
@end

extern DrawGraph *dG;

NS_ASSUME_NONNULL_END
