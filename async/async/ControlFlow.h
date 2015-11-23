//  Created by Isra San Jose on 19/11/2015.

#import "async.h"

@interface NSObject (ControlFlow)

/**
 Run the tasks array of functions in parallel and asynchronously, without waiting until the previous function has completed.
 If any of the functions pass an error to its callback, the main callback is immediately called with the value of the error.
 Once the tasks have completed, the results are passed to the final callback as an array.
 
 Arguments
 ---
 tasks - An array or object containing functions to run.
 callback(err,res) - A callback to run once all the functions have completed successfully.
 
 Example
 ---
 async.parallel(@[^(callbackBlock next) {
    ... operation to do. it will run asynchronously.
    next(err,res);
 },^(callbackBlock next) {
    ... operation to do. it will run asynchronously.
    next(err,res);
 }],^(NSError *err,id res) {
    NSLog(@"err : %@ , res : %@",err,res);
 });
 
 */
+ (void (^)(NSArray *,callbackBlock))parallel;

/**
 Run the functions in the tasks array in series and asynchronously, each one running once the previous function has completed.
 If any functions in the series pass an error to its callback, no more functions are run, and callback is immediately called with the value of the error. 
 Otherwise, callback receives an array of results when tasks have completed.
 
 Arguments
 ---
 tasks - An array or object containing functions to run.
 callback(err,res) - A callback to run once all the functions have completed successfully.
 
 Example
 ---
 async.series(@[^(callbackBlock next) {
    ... operation to do. it will run asynchronously.
    next(err,res);
 },^(callbackBlock next) {
    ... operation to do. it will run asynchronously.
    next(err,res);
 }],^(NSError *err,id res) {
    NSLog(@"err : %@ , res : %@",err,res);
 });
 
 */
+ (void (^)(NSArray *,callbackBlock))series;

/**
 Runs the tasks array of functions in series and asynchronously, each passing their results to the next in the array. 
 However, if any of the tasks pass an error to their own callback, the next function is not executed, 
 and the main callback is immediately called with the error.
 
 Arguments
 ---
 tasks - An array or object containing functions to run.
 callback(err,res) - A callback to run once all the functions have completed successfully.
 
 Example
 ---
 async.waterfall(@[^(id data,waterfallBlock next) {
    ... operation to do. it will run asynchronously.
    next(args,err,res);
 },^(id data,waterfallBlock next) {
    ... operation to do. it will run asynchronously.
    next(args,err,res);
 }],^(NSError *err,id res) {
    NSLog(@"err : %@ , res : %@",err,res);
 });
 
 */
+ (void (^)(NSArray *,callbackBlock))waterfall;

@end
