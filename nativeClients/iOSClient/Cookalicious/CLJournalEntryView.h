//
//  CLJournalEntryView.h
//  Cookalicious
//
//  Created by James Kizer on 12/8/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLJournalEntryModel.h"

@interface CLJournalEntryView : UIView

-(instancetype)initWithJournalEntry:(CLJournalEntryModel *)journalEntry andFrame:(CGRect)frame;


@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *detailTextField;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end
