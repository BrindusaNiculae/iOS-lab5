//
//  PlacesTableViewController.m
//  Places
//
//  Created by ios5 on 7/9/15.
//  Copyright (c) 2015 Brindusa. All rights reserved.
//

#import "PlacesTableViewController.h"
@import GoogleMaps;

@interface PlacesTableViewController ()

@property(strong, atomic) NSMutableDictionary *resultDictionary;
@property(strong, atomic) NSMutableArray *searchKeys;
@property(strong, atomic) GMSPlace *place;

@end


@implementation PlacesTableViewController {
    GMSPlacesClient *_placesClient;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _resultDictionary = [[NSMutableDictionary alloc] init];
    _searchKeys = [[NSMutableArray alloc] init];
    _placesClient = [[GMSPlacesClient alloc] init];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated {
    for (char a = 'a'; a <= 'z'; a++) {
        [self.searchKeys addObject:[NSString stringWithFormat:@"%c", a]];
        [self placesAutocomplete:[NSString stringWithFormat:@"%c", a]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[self.resultDictionary allKeys] count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[self.resultDictionary objectForKey:[self.searchKeys objectAtIndex:section]] count];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    PlacesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(indexPath.row % 2) ? @"placesEvenCell" : @"placesOddCell"];
    
    if( cell == nil) {
        cell = [[PlacesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:(indexPath.row % 2) ? @"placesEvenCell" : @"placesOddCell"];
    }
    

    NSString *key = [self.searchKeys objectAtIndex:indexPath.section];
    NSArray *result = [self.resultDictionary objectForKey:key];
    
    GMSAutocompletePrediction *object =[result objectAtIndex:indexPath.row];
    //cell.textLabel.text = object.attributedFullText.string;
    cell.label.text = object.attributedFullText.string;
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.searchKeys objectAtIndex:section];
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}

-(void) placesAutocomplete:(NSString *) key {
    CLLocationCoordinate2D left = CLLocationCoordinate2DMake(44.437714, 26.070900);
    CLLocationCoordinate2D right = CLLocationCoordinate2DMake(44.431278, 26.082401);
    
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:left coordinate:right];
    
    [_placesClient autocompleteQuery:key
                              bounds:bounds
                              filter:nil
                            callback:^(NSArray *results, NSError *error) {
                                if (error != nil) {
                                    NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                    return;
                                }
                                [self.resultDictionary setObject:results forKey:key];
                                [self.tableView reloadData];
                            }];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self.searchKeys objectAtIndex:indexPath.section];
    NSArray *result = [self.resultDictionary objectForKey:key];
    
    GMSAutocompletePrediction *object =[result objectAtIndex:indexPath.row];
    
    NSString *placeID = object.placeID;
    
    //NSString *placeID = @"ChIJV4k8_9UodTERU5KXbkYpSYs";
    
    [_placesClient lookUpPlaceID:placeID callback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Place Details error %@", [error localizedDescription]);
            return;
        }
        
        if (place != nil) {
            NSLog(@"Place name %@", place.name);
            NSLog(@"Place address %@", place.formattedAddress);
            NSLog(@"Place placeID %@", place.placeID);
            NSLog(@"Place attributions %@", place.attributions);
        } else {
            NSLog(@"No place details for %@", placeID);
        }
        self.place = place;
        [self performSegueWithIdentifier:@"showDetails" sender:self];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"showDetails"])
    {
        // Get reference to the destination view controller
        DetailsViewController *destinationViewController = [segue destinationViewController];
        
        destinationViewController.detailsPlace = self.place;
    }
}

@end
