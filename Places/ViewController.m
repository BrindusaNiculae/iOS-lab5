//
//  ViewController.m
//  Places
//
//  Created by iOS1 on 07/07/15.
//  Copyright (c) 2015 Brindusa. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(weak, nonatomic) IBOutlet UIButton *profileButton;
@property(weak, nonatomic) IBOutlet UIButton *settingsButton;
@property(weak, nonatomic) IBOutlet UIView *profileView;
@property(weak, nonatomic) IBOutlet UIView *settingsView;
@property(strong, nonatomic) Profile *profile;
@property(weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property(weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property(weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property(weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property(weak, nonatomic) IBOutlet UIImageView *profileImage;
@property(weak, nonatomic) IBOutlet UIView *indicator;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *indicatorPosition;


@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profile = [[Profile alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *hideKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:hideKeyboard];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

-(void)keyboardWillShow:(NSNotification *)notification {
    
    
    CGRect keyboard = [[notification.userInfo
                             objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect frame = self.view.frame;
    
    if([_firstNameTextField isFirstResponder]) {
        frame.origin.y = -[self adjustFrameOriginOfViewFromKeyboard:keyboard andCurrentTextView:_firstNameTextField];
    }
    if([_lastNameTextField isFirstResponder]) {
         frame.origin.y = -[self adjustFrameOriginOfViewFromKeyboard:keyboard andCurrentTextView:_lastNameTextField];
    }
    [self.view setFrame:frame];
}

-(void)keyboardWillHide {
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    [self.view setFrame:frame];
}

-(CGFloat) adjustFrameOriginOfViewFromKeyboard:(CGRect)keyboard andCurrentTextView:(UITextField *)textField {
    CGFloat textFieldY = textField.frame.origin.y;
    CGFloat frameHeight = self.view.frame.size.height;
    CGFloat keyboardHeight = keyboard.size.height;
    if ( frameHeight < (keyboardHeight + textFieldY)) {
         return (55 + (keyboardHeight + textFieldY + textField.frame.size.height) - frameHeight);
    } else return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction) buttonPressed:(UIButton *)sender {
    
    if(![sender isSelected]) {

        if ([sender isEqual:_profileButton]) {
            [_profileView setHidden:NO];
            [_settingsView setHidden:YES];
            [_profileButton setSelected:YES];
            [_settingsButton setSelected:NO];
        } else if ([sender isEqual:_settingsButton]) {
            [_profileView setHidden:YES];
            [_settingsView setHidden:NO];
            [_profileButton setSelected:NO];
            [_settingsButton setSelected:YES];
        }
    }
    [self updateIndicatorPositionWithDuration:0.3];
}

-(IBAction) dateSet:(UIDatePicker *)sender {
    if(![sender isSelected]) {
        self.profile.birthday = sender.date;
    }
}

-(IBAction) imageSet:(id)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Take photo",
                            @"Select photo from galery",
                            nil];
    [popup showInView:self.view];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    switch(buttonIndex) {
        case 0:
        {
            [self uploadPhotoFrom:UIImagePickerControllerSourceTypeCamera];
        }
            break;
        case 1:
        {
            [self uploadPhotoFrom:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        default:
            break;
    }
}

-(void) uploadPhotoFrom:(UIImagePickerControllerSourceType) sourceType {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    imagePicker.sourceType = sourceType;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if([textField isEqual:_firstNameTextField]) {
        self.profile.firstName = textField.text;
    } else if ([textField isEqual: _lastNameTextField]) {
         self.profile.lastName = textField.text;
  }
    }

#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *media = info[UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if([media isEqualToString:(NSString *)kUTTypeImage]) {
        _profile.photo = info[UIImagePickerControllerOriginalImage];
        _profileImage.image = _profile.photo;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                       message:@"Set all text fields!"
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];

    
    if([textField isEqual:_firstNameTextField]) {
        [_lastNameTextField becomeFirstResponder];
    } else if ([textField isEqual: _lastNameTextField]) {
        [_lastNameTextField resignFirstResponder];
        if([self.profile.firstName length] == 0) {
            [theAlert show];
            _firstNameLabel.textColor = [UIColor redColor];
            
        }
        if ([self.profile.lastName length] == 0) {
            [theAlert show];
            _lastNameLabel.textColor = [UIColor redColor];
        }
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if([textField isEqual:_firstNameTextField]) {
        _firstNameLabel.textColor = [UIColor blackColor];
        
    }
    if ([textField isEqual: _lastNameTextField]) {
        _lastNameLabel.textColor = [UIColor blackColor];
    }
    return YES;
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self updateIndicatorPositionWithDuration:0];
}

-(void) updateIndicatorPositionWithDuration:(CGFloat) duration {
    if([_profileButton isSelected]) {
        _indicatorPosition.constant = 0;
    } else if ([_settingsButton isSelected]) {
        _indicatorPosition.constant = _settingsButton.frame.size.width;
    }
    [UIView animateWithDuration:duration
                     animations:^{
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];

    
}

@end
