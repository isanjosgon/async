//
//  ISJViewController.m
//  async
//
//  Created by Isra San Jose Gonzalez on 12/14/2015.
//  Copyright (c) 2015 Isra San Jose Gonzalez. All rights reserved.
//

#import "ISJViewController.h"

#import <async/async.h>

@interface ISJViewController ()

@end

@implementation ISJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    async.parallel(@[^(callbackBlock next) {
        NSLog(@"block1");
        sleep(3);
        next(nil,@"block1");
    },^(callbackBlock next) {
        NSLog(@"block2");
        sleep(4);
        next(nil,@"block2");
    },^(callbackBlock next) {
        NSLog(@"block3");
        sleep(2);
        next(nil,@"block3");
    }],^(NSError *err,id res) {
        NSLog(@"err : %@ , res : %@",err,res);
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
