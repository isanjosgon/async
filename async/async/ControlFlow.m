//  Created by Isra San Jose on 19/11/2015.

#import "ControlFlow.h"

static NSString *descriptionError = @"Operation was unsuccessful.";
static NSString *reasonError = @"The %ld operation failed.";
static NSString *parametersAssert = @"First argument must be an array of methods";

@implementation NSObject (ControlFlow)

+ (void)baseValidationArgs:(NSArray *)operations callback:(callbackBlock)completionBlock
{
    NSAssert([operations isKindOfClass:[NSArray class]],parametersAssert);
    NSParameterAssert(operations.count > 0);
    NSParameterAssert(completionBlock);
}

+ (NSError *)toError:(id)err atIndex:(NSInteger)iterator
{
    if ([err isKindOfClass:[NSError class]]) {
        return err;
    }
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey:[err isKindOfClass:[NSString class]] ? err : descriptionError,
                               NSLocalizedFailureReasonErrorKey:[NSString stringWithFormat:reasonError,iterator + 1]
                               };
    return [[NSError alloc] initWithDomain:@"async" code:0 userInfo:userInfo];
}

+ (NSDictionary *)toObject:(id)res atIndex:(NSInteger)iterator
{
    return @{@"operation":[NSString stringWithFormat:@"%ld",(long)iterator + 1],@"result":res ? res : [NSNull null]};
}

+ (void (^)(NSArray *,callbackBlock))parallel
{
    return ^(NSArray *operations,callbackBlock completionBlock)
    {
        [self baseValidationArgs:operations callback:completionBlock];
        
        __block NSMutableArray *results = [NSMutableArray arrayWithCapacity:operations.count];
        __block BOOL stop = NO;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
            dispatch_group_t group = dispatch_group_create();
            for (NSInteger iterator = 0; iterator < operations.count; iterator++) {
                void (^ block)(callbackBlock) = [operations objectAtIndex:iterator];
                dispatch_group_enter(group);
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
                    block(^(id err,id res) {
                        if (err) {
                            NSError *error = [self toError:err atIndex:iterator];
                            stop = YES;
                            dispatch_group_leave(group);
                            dispatch_async(dispatch_get_main_queue(),^{
                                completionBlock(error,results);
                            });
                            return;
                        }
                        [results addObject:[self toObject:res atIndex:iterator]];
                        dispatch_group_leave(group);
                    });
                });
            }
            dispatch_group_notify(group,dispatch_get_main_queue(),^{
                if (!stop) {
                    completionBlock(nil,results);
                }
            });
        });
    };
}

+ (void (^)(NSArray *,callbackBlock))series
{
    return ^(NSArray *operations,callbackBlock completionBlock)
    {
        [self baseValidationArgs:operations callback:completionBlock];
        
        __block NSMutableArray *results = [NSMutableArray arrayWithCapacity:operations.count];
        __block NSError *error = nil;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
            for (NSInteger iterator = 0; iterator < operations.count; iterator++) {
                void (^ block)(callbackBlock) = [operations objectAtIndex:iterator];
                dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
                    if (error) {
                        return;
                    }
                    block(^(id err,id res) {
                        if (err) {
                            error = [self toError:err atIndex:iterator];
                            return;
                        }
                        [results addObject:[self toObject:res atIndex:iterator]];
                    });
                });
            }
            completionBlock(error,results);
        });
    };
}

+ (void (^)(NSArray *,callbackBlock))waterfall
{
    return ^(NSArray *operations,callbackBlock completionBlock)
    {
        [self baseValidationArgs:operations callback:completionBlock];
    
        __block NSMutableArray *results = [NSMutableArray arrayWithCapacity:operations.count];
        __block NSError *error = nil;
        __block id args = nil;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
            for (NSInteger iterator = 0; iterator < operations.count; iterator++) {
                void (^ block)(id,waterfallBlock) = [operations objectAtIndex:iterator];
                dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
                    if (error) {
                        return;
                    }
                    block(args,^(id data,id err,id res) {
                        if (err) {
                            error = [self toError:err atIndex:iterator];
                            return;
                        }
                        [results addObject:[self toObject:res atIndex:iterator]];
                        args = data;
                    });
                });
            }
            completionBlock(error,results);
        });
    };
}

@end
