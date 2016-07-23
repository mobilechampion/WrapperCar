//
//  TextViewTableViewCell.h
//  HeartCMS
//
//  Created by Nguyen Thanh Hung on 10/2/14.
//  Copyright (c) 2014 NguyenHung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;


@end
