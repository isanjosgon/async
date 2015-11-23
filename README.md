# async

Async is a utility framework which provides asynchronous working to help processing background tasks without blocking the UI.

It is inspired by Javascript module https://github.com/caolan/async.

### Quick Example ###

```sh
async.parallel(@[^(callbackBlock next) {
  NSLog(@"block1");
  sleep(2);
  next(nil,@"block1");
},^(callbackBlock next) {
  NSLog(@"block2");
  sleep(7);
  next(nil,@"block2");
},^(callbackBlock next) {
  NSLog(@"block3");
  sleep(4);
  next(nil,@"block3");
}],^(NSError *err,id res) {
  NSLog(@"err : %@ , res : %@",err,res);
});
```

### How to use ###

Ready in 1 minute. Just following the next steps:
* add the framework to your project (drag and drop).
* go to your target >> General tab
* add the async.framework to your 'Embedded Binaries'
* import the framework #import <async/async.h>
* run and done!

Final Xcode configuration

![image](http://i67.tinypic.com/yeb04.png)

### Control Flow ###

Available methods on the framework:
* parallel
* series
* waterfall

# Control Flow

### parallel ###

Run the tasks array of functions in parallel and asynchronously, without waiting until the previous function has completed. If any of the functions pass an error to its callback, the main callback is immediately called with the value of the error. Once the tasks have completed, the results are passed to the final callback as an array.

**Arguments**

tasks - An array or object containing functions to run.
callback(err,res) - A callback to run once all the functions have completed successfully.

**Example**

```sh
async.parallel(@[^(callbackBlock next) {
  // do some stuff ... it will run asynchronously
  next(nil,@"one");
},^(callbackBlock next) {
  // do some stuff ... it will run asynchronously
  next(nil,@"two");
}],^(NSError *err,id res) {
  NSLog(@"err : %@ , res : %@",err,res);
});
```

### series ###

Run the functions in the tasks array in series and asynchronously, each one running once the previous function has completed. If any functions in the series pass an error to its callback, no more functions are run, and callback is immediately called with the value of the error. Otherwise, callback receives an array of results when tasks have completed.

**Arguments**

tasks - An array or object containing functions to run.
callback(err,res) - A callback to run once all the functions have completed successfully.

**Example**

```sh
async.series(@[^(callbackBlock next) {
  // do some stuff ... it will run asynchronously
  next(nil,@"one");
},^(callbackBlock next) {
  // do some stuff ... it will run asynchronously
  next(nil,@"two");
}],^(NSError *err,id res) {
  NSLog(@"err : %@ , res : %@",err,res);
});
```

### waterfall ###

Runs the tasks array of functions in series and asynchronously, each passing their results to the next in the array. However, if any of the tasks pass an error to their own callback, the next function is not executed,
and the main callback is immediately called with the error.

**Arguments**

tasks - An array or object containing functions to run.
callback(err,res) - A callback to run once all the functions have completed successfully.

**Example**

```sh
async.waterfall(@[^(id data,waterfallBlock next) {
  // do some stuff ... it will run asynchronously
  next(@"one",nil,@"one");
},^(id data,waterfallBlock next) {
  // do some stuff ... it will run asynchronously
  next(nil,nil,@"two");
}],^(NSError *err,id res) {
  NSLog(@"err : %@ , res : %@",err,res);
});
```
