//
//  ViewController.m
//  test_BDPhotoPicker
//
//  Created by 王建斌 on 2018/4/9.
//  Copyright © 2018年 buydeem. All rights reserved.
//

#import "ViewController.h"
#import "BDPhotoPickerController.h"

@interface ViewController ()<BDPhotoPickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor blueColor];
    btn.frame = CGRectMake(10, 100, 100, 44);
    [btn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)test {
    BDPhotoPickerController *pc = [[BDPhotoPickerController alloc] init];
    pc.delegate = self;
    [self presentViewController:pc animated:YES completion:NULL];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)BDPhotoPickerController:(BDPhotoPickerController*)picker didFinishPickingWithAssets:(NSArray<PHAsset*>*)arrAssets
{
    NSLog(@"%@",arrAssets);
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)BDPhotoPickerControllerDidCancelPicking:(BDPhotoPickerController*)picker
{
    
}


@end
