//
//  ViewController.m
//  NotificationQuicklyReplyDemo
//
//  Created by yyp on 15/5/15.
//  Copyright (c) 2015年 Mingdao. All rights reserved.
//

#import "ViewController.h"
#import "EditViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction)];
    
}

- (void)editAction
{
    EditViewController *vc = [[EditViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
