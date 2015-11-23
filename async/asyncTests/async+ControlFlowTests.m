//  Created by Isra San Jose on 19/11/2015.

#import <XCTest/XCTest.h>

#import "async.h"

@interface async_ControlFlowTests : XCTestCase

@end

@implementation async_ControlFlowTests

- (void)testParallel
{
    async.parallel(@[^(callbackBlock next) {
        NSLog(@"block1");
        next(nil,@"block1");
    },^(callbackBlock next) {
        NSLog(@"block2");
        next(nil,@"block2");
    },^(callbackBlock next) {
        NSLog(@"block3");
        next(nil,@"block3");
    }],^(NSError *err,id res) {
        NSLog(@"err : %@ , res : %@",err,res);
    });
}

- (void)testSeries
{
    async.series(@[^(callbackBlock next) {
        NSLog(@"block1");
        next(nil,@"block1");
    },^(callbackBlock next) {
        NSLog(@"block2");
        next(nil,@"block2");
    },^(callbackBlock next) {
        NSLog(@"block3");
        next(nil,@"block3");
    }],^(NSError *err,id res) {
        NSLog(@"err : %@ , res : %@",err,res);
    });
}

- (void)testWaterfall
{
    async.waterfall(@[^(id data,waterfallBlock next) {
        NSLog(@"block1 %@",data);
        next(@"block1",nil,@"block1");
    },^(id data,waterfallBlock next) {
        NSLog(@"block2 %@",data);
        next(@"block2",nil,@"block2");
    },^(id data,waterfallBlock next) {
        NSLog(@"block3 %@",data);
        next(@"block3",nil,@"block3");
    }],^(NSError *err,id res) {
        NSLog(@"err : %@ , res : %@",err,res);
    });
}

@end
