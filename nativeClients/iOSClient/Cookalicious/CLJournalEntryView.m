//
//  CLJournalEntryView.m
//  Cookalicious
//
//  Created by James Kizer on 12/8/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import "CLJournalEntryView.h"
#import "CLNetworkingController.h"

@interface CLJournalEntryView()



@end

@implementation CLJournalEntryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithJournalEntry:(CLJournalEntryModel *)journalEntry andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.publishPermissions = publishPermissions;
//        self.defaultAudience = defaultAudience;
//        [self initialize];
        
        CGSize viewSize = frame.size;
        self.backgroundColor = [UIColor whiteColor];
        
        
        self.userLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, (viewSize.width-20)/2, 21)];
        [self addSubview:self.userLabel];
        
        self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(viewSize.width/2, 10, (viewSize.width-20)/2, 21)];
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.dateLabel];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 31, (viewSize.width-20), 21)];
        [self addSubview:self.titleLabel];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.detailTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 52, (viewSize.width-20), 150)];
        [self addSubview:self.detailTextField];
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake((viewSize.width-256)/2, 202, 256, 256)];
        [self addSubview:self.imageView];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //self.imageView.center = CGPointMake(self.center.x, self.imageView.center.y);

    }
    return self;
}

@end
