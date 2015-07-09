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
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if( cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:cellIdentifier];
    }
    

    //cell.textLabel.text = [NSString stringWithFormat:@"Row %lu, In section %lu.", indexPath.row, indexPath.section];
    NSString *key = [self.searchKeys objectAtIndex:indexPath.section];
    NSArray *result = [self.resultDictionary objectForKey:key];
    
    GMSAutocompletePrediction *object =[result objectAtIndex:indexPath.row];
    cell.textLabel.text = object.attributedFullText.string;
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
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
