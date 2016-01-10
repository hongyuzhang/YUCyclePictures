//
//  ViewController.m
//  YUCycle
//
//  Created by 张洪毓 on 15/12/13.
//  Copyright © 2015年 张洪毓. All rights reserved.
//

#import "ViewController.h"

#define rect self.view.bounds


@interface ViewController () <UIScrollViewDelegate>

// scrollview
@property (weak, nonatomic)  UIScrollView * scrollView;
// 当前显示的图片
@property (weak, nonatomic)  UIImageView * currentImageView;
// 左边显示的图片
@property (weak, nonatomic)  UIImageView * leftImageView;
// 右边显示的图片
@property (weak, nonatomic)  UIImageView * rightImageView;

// pageControl
@property (weak, nonatomic)  UIPageControl * imagePageControl;

// 定时器
@property (strong, nonatomic)  NSTimer * timer;
// 图片数组
@property (nonatomic,strong) NSArray *imageAry;

@property (nonatomic,assign) UIPanGestureRecognizer *pan;
@end

@implementation ViewController

#pragma mark 懒加载图片
-(NSArray *)imageAry{
    if (!_imageAry) {
        _imageAry = @[
                      [UIImage imageNamed:@"1.jpg"],
                      [UIImage imageNamed:@"2.jpg"],
                      [UIImage imageNamed:@"3.jpg"],
                      [UIImage imageNamed:@"4.jpg"],
                      [UIImage imageNamed:@"5.jpg"],
                      [UIImage imageNamed:@"6.jpg"],
                      [UIImage imageNamed:@"7.jpg"]
                      ];
    }
    return _imageAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    [self startTimer];
}

-(void)setupUI{
    
    // 1. scrollview
    UIScrollView * tempScrollview =[[UIScrollView alloc]init];
    [self.view addSubview:tempScrollview];
    self.scrollView = tempScrollview;
    tempScrollview.delegate = self;
    tempScrollview.pagingEnabled = YES;
    tempScrollview.showsHorizontalScrollIndicator = NO;
    tempScrollview.showsVerticalScrollIndicator = NO;
    
    // 添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:tempScrollview action:@selector(test)];
    self.pan = pan;
    
    // 2.当前显示的图片
    UIImageView * currentImageView = [[UIImageView alloc]init];
    [tempScrollview addSubview:currentImageView];
    self.currentImageView = currentImageView;
//    self.currentImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    // 3.左边的图片
    UIImageView * leftImageView = [[UIImageView alloc]init];
    [tempScrollview addSubview:leftImageView];
    self.leftImageView = leftImageView;
    
    // 4.右边的图片
    UIImageView * rightImageView = [[UIImageView alloc]init];
    [tempScrollview addSubview:rightImageView];
    self.rightImageView = rightImageView;
    
    // 5.pageControl
    UIPageControl * imagePageContol = [[UIPageControl alloc]init];
    [self.view addSubview:imagePageContol];
    self.imagePageControl = imagePageContol;
    
    
#pragma mark 设置frame
    
    CGFloat selfHeight = rect.size.height;
    CGFloat selfWidth = rect.size.width;
    
    self.scrollView.frame = rect;

    self.scrollView.contentSize = CGSizeMake(selfWidth * 3, 0);
    
    self.currentImageView.frame = CGRectMake(selfWidth, 0, selfWidth, selfHeight);
    
    self.leftImageView.frame = CGRectMake(0, 0, selfWidth, selfHeight);
    
    self.rightImageView.frame = CGRectMake(2 * selfWidth, 0, selfWidth, selfHeight);
    
    self.imagePageControl.numberOfPages = self.imageAry.count;
    self.imagePageControl.currentPage = 0;
    /**
     *      UIControlContentHorizontalAlignmentCenter = 0,
     UIControlContentHorizontalAlignmentLeft   = 1,
     UIControlContentHorizontalAlignmentRight  = 2,
     UIControlContentHorizontalAlignmentFill   = 3,
     */

    self.imagePageControl.frame = CGRectMake( 0.5*selfWidth - 25 ,selfHeight -25, 50, 20);
    
    [self updateImage];
}

-(void)test{
    if (self.pan.state == UIGestureRecognizerStateBegan) {
        [self endTimer];
    }else if (self.pan.state == UIGestureRecognizerStateChanged) {
        [self endTimer];
    }else if (self.pan.state == UIGestureRecognizerStateEnded) {
        [self startTimer];
    }
}


-(void)updateImage{
    
    NSInteger index = self.imagePageControl.currentPage;
        NSLog(@"index:%ld",index);
    
    if (index == 0) {
        
        self.currentImageView.image = self.imageAry[0];
        self.leftImageView.image = [self.imageAry lastObject];
        self.rightImageView.image = self.imageAry[1];
        
        self.currentImageView.tag = 0;
        self.leftImageView.tag = self.imageAry.count - 1;
        self.rightImageView.tag = 1;
        
        
    }else if(index == self.imageAry.count - 1){
        
        
        self.currentImageView.image = [self.imageAry lastObject];
        self.leftImageView.image = self.imageAry[self.imageAry.count-2];
        self.rightImageView.image = self.imageAry[0];
        
        
        self.currentImageView.tag = self.imageAry.count - 1;
        self.leftImageView.tag = self.imageAry.count - 2;
        self.rightImageView.tag = 0;
        
    }else{
        
        self.currentImageView.image = self.imageAry[index];
        self.leftImageView.image = self.imageAry[index - 1];
        self.rightImageView.image = self.imageAry[index + 1];
        
        self.currentImageView.tag = index;
        self.leftImageView.tag = index - 1;
        self.rightImageView.tag = index + 1;
    }
    
    self.scrollView.contentOffset = CGPointMake(rect.size.width, 0);
}

- (void)nextPick{
    [self.scrollView setContentOffset:CGPointMake(2 * rect.size.width, 0) animated:YES];
}


#pragma mark scrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.scrollView.contentOffset.x > rect.size.width * 1.5) {
        self.imagePageControl.currentPage = self.rightImageView.tag;
    }else if (self.scrollView.contentOffset.x > rect.size.width * 0.5){
        self.imagePageControl.currentPage = self.currentImageView.tag;
    }else{
        self.imagePageControl.currentPage = self.leftImageView.tag;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self endTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self updateImage];
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self updateImage];
}



#pragma mark 定时器的启动与停止
- (void)startTimer{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPick) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)endTimer{
    [self.timer invalidate];
    self.timer = nil;
}


@end
