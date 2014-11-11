//
//  MainViewController.m
//  GlobalAir
//
//  Created by Mathieu White on 2014-11-10.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "MainViewController.h"
#import "AeroportsDuMonde.h"
#import "Aeroport.h"
#import "AirportDetailViewController.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) AeroportsDuMonde *airports;
@property (nonatomic, strong) NSArray *sectionTitles;

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Navigation Bar Title
    [self setTitle: NSLocalizedString(@"Airports", nil)];
    
    // Initialize the airports
    AeroportsDuMonde *airports = [[AeroportsDuMonde alloc] init];
    
    // Initialize the airport index titles
    NSArray *sectionTitles = [[airports.dictionnaireAeroports allKeys] sortedArrayUsingSelector: @selector(localizedStandardCompare:)];
    
    // Initialize the table view
    UITableView *tableView = [[UITableView alloc] init];
    [tableView setTranslatesAutoresizingMaskIntoConstraints: NO];
    [tableView setDelegate: self];
    [tableView setDataSource: self];
    
    // Add each component to the view
    [self.view addSubview: tableView];
    
    // Set each component to a property
    [self setAirports: airports];
    [self setSectionTitles: sectionTitles];
    [self setTableView: tableView];
    
    // Auto Layout
    [self setupConstraints];
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    
    [self.tableView deselectRowAtIndexPath: selectedIndexPath animated: YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Auto Layout Methods

- (void) setupConstraints
{
    NSDictionary *views = @{@"tableView" : [self tableView]};
    
    NSArray *tableViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[tableView]|"
                                                                                      options: 0
                                                                                      metrics: nil
                                                                                        views: views];
    
    NSArray *tableViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[tableView]|"
                                                                                    options: 0
                                                                                    metrics: nil
                                                                                      views: views];
    
    [self.view addConstraints: tableViewHorizontalConstraints];
    [self.view addConstraints: tableViewVerticalConstraints];
}

#pragma mark UITableViewDataSource Methods

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
    return [self.sectionTitles count];
}

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section
{
    NSString *sectionTitle = [self.sectionTitles objectAtIndex: section];
    NSArray *sectionAirports = [self.airports.dictionnaireAeroports objectForKey: sectionTitle];
    return [sectionAirports count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier: identifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: identifier];
    
    NSString *sectionTitle = [self.sectionTitles objectAtIndex: [indexPath section]];
    NSArray *sectionAirports = [self.airports.dictionnaireAeroports objectForKey: sectionTitle];
    
    Aeroport *airport = [sectionAirports objectAtIndex: [indexPath row]];
    
    [cell.textLabel setText: [airport code]];
    [cell.detailTextLabel setText: [NSString stringWithFormat: @"%@, %@", [airport ville], [airport pays]]];
    [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (NSString *) tableView: (UITableView *) tableView titleForHeaderInSection: (NSInteger) section
{
    return [self.sectionTitles objectAtIndex: section];
}

- (NSArray *) sectionIndexTitlesForTableView: (UITableView *) tableView
{
    NSArray *keys = [[self.airports.dictionnaireAeroports allKeys] sortedArrayUsingSelector: @selector(localizedStandardCompare:)];
    return keys;
}

- (NSInteger) tableView: (UITableView *) tableView sectionForSectionIndexTitle: (NSString *) title atIndex: (NSInteger) index
{
    return [self.sectionTitles indexOfObject: title];
}

#pragma mark UITableViewDelegate Methods

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    return 48.0f;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    NSString *sectionTitle = [self.sectionTitles objectAtIndex: [indexPath section]];
    NSArray *sectionAirports = [self.airports.dictionnaireAeroports objectForKey: sectionTitle];
    
    Aeroport *airport = [sectionAirports objectAtIndex: [indexPath row]];
    
    AirportDetailViewController *detailViewController = [[AirportDetailViewController alloc] initWithAirport: airport];
    
    [self.navigationController pushViewController: detailViewController animated: YES];
}

@end
