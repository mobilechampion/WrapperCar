//
//  TextFieldTableViewCell.h
//  HeartCMS
//
//  Created by Nguyen Thanh Hung on 10/2/14.
//  Copyright (c) 2014 NguyenHung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *textField;


@end
