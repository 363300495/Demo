//
//  YKXTextView.m
//  YouKanXia
//
//  Created by 汪立 on 2017/5/19.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXTextView.h"

@implementation YKXTextView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self YKXCustom];
    }
    return self;
}

- (void)YKXCustom{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}

- (void)setPlaceholder:(NSString *)placeholder{
    _myPlaceholder = [placeholder copy];
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _myPlaceholderColor = placeholderColor;
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text{
    
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)textDidChange{

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    
    if ([self hasText]) return;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = self.myPlaceholderColor ? self.myPlaceholderColor : [UIColor grayColor];
    attrs[NSFontAttributeName] = self.font ? self.font : [UIFont systemFontOfSize:12.0f];
    
    CGFloat x = 5;
    CGFloat y = 8;
    CGFloat w = self.frame.size.width - 2 * x;
    CGFloat h = self.frame.size.height - 2 * y;
    CGRect placeholderRect = CGRectMake(x, y, w, h);
    [self.myPlaceholder drawInRect:placeholderRect withAttributes:attrs];
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
