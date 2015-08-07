//
//  ViewController.m
//  循环scrollView
//
//  Created by apple on 15/8/3.
//  Copyright (c) 2015年 wubangjun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) UIImageView *firstImage;
@property (nonatomic, strong) UIImageView *middleImage;
@property (nonatomic, strong) UIImageView *lastImage;
@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic, assign) int curIndex;
@end

@implementation ViewController

#pragma mark ==============================view生命周期方法===================
- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageViews = [NSMutableArray array];
    
    for (int i = 1; i<=5; i++) {
        NSString *name = [NSString stringWithFormat:@"tu%d.png",i];
        UIImage *image = [UIImage imageNamed:name];
        UIImageView *iv = [[UIImageView alloc] init];
        iv.image = image;
        [_imageViews addObject:iv];
    }
    _pageControl.numberOfPages = self.imageViews.count;
   
    self.curIndex = 0;
    if (self.imageViews.count>1) {
        [self calcIndexByCurrentIndex];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    self.scrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
    [super viewWillAppear:animated];

    if (self.imageViews.count > 1) {
        [self addScrollImageViews];
        self.scrollView.contentSize = CGSizeMake(3 * self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:YES];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoPrevPage) userInfo:nil repeats:YES];
    }else{
        self.scrollView.contentSize = CGSizeMake(1 * self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        if (self.imageViews.count==1) {
            self.middleImage = [[UIImageView alloc] init];
            self.middleImage.image = [self.imageViews[0] image];
            self.middleImage.frame = CGRectMake(0, 0, self.scrollView.frame.size.width,  self.scrollView.frame.size.height);
            [self.scrollView addSubview:self.middleImage];
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}


#pragma mark ==============================UIScrollViewDelegate===================
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x;
    int curPage = x/scrollView.frame.size.width;
    if (x==0) {
        [self nextPage:NO];
    }else if(curPage==2){
        [self prevPage:NO];
    }
    _pageControl.currentPage = _curIndex;
}

#pragma mark ==============================自定义方法===================
-(void)addScrollImageViews{
    self.firstImage = [[UIImageView alloc] init];
    self.middleImage = [[UIImageView alloc] init];
    self.lastImage = [[UIImageView alloc] init];
    
    [self initImage];
    
    [self.scrollView addSubview:self.firstImage];
    [self.scrollView addSubview:self.middleImage];
    [self.scrollView addSubview:self.lastImage];
}
-(void)initImage{
    self.firstImage.image = [self.imageViews[[self.arr[0] intValue]] image];
    self.firstImage.frame = CGRectMake(0, 0, self.scrollView.frame.size.width,  self.scrollView.frame.size.height);
    
    self.middleImage.image = [self.imageViews[[self.arr[1] intValue]] image];
    self.middleImage.frame = CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width,  self.scrollView.frame.size.height);
    
    self.lastImage.image = [self.imageViews[[self.arr[2] intValue]] image];
    self.lastImage.frame = CGRectMake(2*self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width,  self.scrollView.frame.size.height);
}
-(void)nextPage:(BOOL)anmiation{
    if (_curIndex==0) {
        _curIndex = (int)(self.imageViews.count-1);
    }else{
        _curIndex--;
    }
    [self calcIndexByCurrentIndex];
    _pageControl.currentPage = _curIndex;
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:anmiation];
    [self initImage];

}
-(void)prevPage:(BOOL)anmiation{
    if (_curIndex==self.imageViews.count-1) {
        _curIndex = 0;
    }else{
        _curIndex++;
    }
    [self calcIndexByCurrentIndex];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:anmiation];
    _pageControl.currentPage = _curIndex;
    [self initImage];
}

-(void)autoNextPage{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x - self.scrollView.frame.size.width, 0) animated:YES];
}
-(void)autoPrevPage{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + self.scrollView.frame.size.width, 0) animated:YES];
}

-(void)calcIndexByCurrentIndex{
    if (_curIndex==0) {
        self.arr = [NSMutableArray arrayWithObjects:@(self.imageViews.count-1),@(_curIndex),@(_curIndex+1), nil];
    }else if(_curIndex==self.imageViews.count-1){
        self.arr = [NSMutableArray arrayWithObjects:@(_curIndex-1),@(_curIndex),@((_curIndex+1)%self.imageViews.count), nil];
    }else{
        self.arr = [NSMutableArray arrayWithObjects:@(_curIndex-1),@(_curIndex),@(_curIndex+1), nil];
    }
}


@end
