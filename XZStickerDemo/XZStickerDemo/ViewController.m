//
//  ViewController.m
//  XZStickerDemo
//
//  Created by 徐章 on 16/5/5.
//  Copyright © 2016年 徐章. All rights reserved.
//

#import "ViewController.h"
#import "XZStickerView.h"


@interface ViewController ()
@property (strong, nonatomic)  UIImageView *imageView;
@property (strong, nonatomic) UIView *preView;
@property (strong, nonatomic) XZStickerView *stickerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 282, 372)];
    self.imageView.image = [UIImage imageNamed:@"image"];
    [self.view addSubview:self.imageView];
    self.imageView.center = self.view.center;
    
    
    self.imageView.layer.borderWidth = 1.0f;
    self.imageView.layer.borderColor = [UIColor redColor].CGColor;
    self.imageView.userInteractionEnabled = YES;
    self.imageView.layer.masksToBounds = YES;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addStickerBtn_Pressed:(id)sender {
    
    self.stickerView = [[XZStickerView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    self.stickerView.backgroundColor = [UIColor clearColor];
    [self.imageView addSubview:self.stickerView];
}

- (IBAction)completeBtn:(id)sender {

    if (!self.stickerView)
        return;
    
    self.preView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    self.preView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.preView];
    
    UIButton *dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 40, [UIScreen mainScreen].bounds.size.width, 40)];
    [dismissBtn setTitle:@"关闭" forState:UIControlStateNormal];
    dismissBtn.backgroundColor = [UIColor redColor];
    [dismissBtn addTarget:self action:@selector(dismissBtn_Pressed) forControlEvents:UIControlEventTouchUpInside];
    [self.preView addSubview:dismissBtn];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, [UIScreen mainScreen].bounds.size.width - 20.0f, [UIScreen mainScreen].bounds.size.height - 80)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.preView addSubview:imageView];
    
    UIImage *image =[self.stickerView generateImage];
    imageView.image = image;
    
    [UIView animateWithDuration:0.5 animations:^{
       
        self.preView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
    } completion:^(BOOL finished) {
    }];

}

- (void)dismissBtn_Pressed{

    [UIView animateWithDuration:0.5 animations:^{
        
        self.preView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
    } completion:^(BOOL finished) {
        
        [self.preView removeFromSuperview];
    }];
}

@end
