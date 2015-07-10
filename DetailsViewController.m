//
//  DetailsViewController.m
//  Places
//
//  Created by ios5 on 7/10/15.
//  Copyright (c) 2015 Brindusa. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@property(weak, nonatomic) IBOutlet UITextView *textBox;
@property(weak, nonatomic) IBOutlet MKMapView *map;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textBox.text = [NSString stringWithFormat:@"Name:\n   %@\n\n\nAddress:\n   %@\n\n\nAttributions:\n   %@\n\n\nPhoneNumber:\n   %@ \n\n\n",
                         self.detailsPlace.name, self.detailsPlace.formattedAddress, self.detailsPlace.attributions, self.detailsPlace.phoneNumber];
    self.title = self.detailsPlace.name;
    

}

-(void)viewWillAppear:(BOOL)animated {
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.detailsPlace.coordinate, 1600, 1600);
    [self.map setRegion:viewRegion animated:YES];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:self.detailsPlace.coordinate];
    [annotation setTitle:self.detailsPlace.name];
    [self.map addAnnotation:annotation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
