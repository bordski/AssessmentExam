//
//  XMLInformationTableViewController.m
//  MichaelXernanBordonadaAssessment
//
//  Created by Diversify BPO on 11/23/13.
//
//

#import "XMLInformationTableViewController.h"
#import "XMLInformationTableViewCell.h"
#import "XMLLocationTableViewCell.h"

static NSString *informationIdentifier = @"InformationCell";
static NSString *businessLocationIdentifier = @"LocationCell";

@interface XMLInformationTableViewController () <NSXMLParserDelegate>


@property (strong, nonatomic) NSMutableDictionary *xmlInformationDictionary;
@property (strong, nonatomic) NSMutableDictionary *xmlLocationDictionary;
@property (strong, nonatomic) NSMutableArray *sectionObjects;
@property (strong, nonatomic) NSMutableArray *currentSection;
@property (strong, nonatomic) NSMutableString *xmlCurrentValue;
@property (strong, nonatomic) NSURL *xmlURL;

@end

@implementation XMLInformationTableViewController

#pragma mark - Synthesize

@synthesize xmlInformationDictionary = _xmlInformationDictionary;
@synthesize xmlLocationDictionary = _xmlLocationDictionary;
@synthesize sectionObjects = _sectionObjects;
@synthesize currentSection = _currentSection;
@synthesize xmlCurrentValue = _xmlCurrentValue;
@synthesize xmlURL = _xmlURL;

#pragma mark - Getters


//Will hold the main element for location of the xml file
//note: getter overridden to avoid nil values
- (NSMutableArray *)sectionObjects
{
    if (!_sectionObjects) {
        _sectionObjects = @[].mutableCopy;
    }
    
    return _sectionObjects;
}

- (NSMutableArray *)currentSection
{
    if (!_currentSection) {
        _currentSection = @[].mutableCopy;
    }
    
    return _currentSection;
}

//will hold the information inside of each element
//note: getter overridden to avoid nil values
- (NSMutableDictionary *)xmlInformationDictionary
{
    if (!_xmlInformationDictionary) {
        _xmlInformationDictionary = @{}.mutableCopy;
    }
    
    return _xmlInformationDictionary;
}

- (NSMutableDictionary *)xmlLocationDictionary
{
    if (!_xmlLocationDictionary) {
        _xmlLocationDictionary = @{}.mutableCopy;
    }
    
    return _xmlLocationDictionary;
}

//will hold the characters found in each element object
//note: getter overridden to avoid nil values
- (NSMutableString *)xmlCurrentValue
{
    if (!_xmlCurrentValue) {
        _xmlCurrentValue = @"".mutableCopy;
    }
    
    return _xmlCurrentValue;
}

//holds the location of the xml to be parsed
//note: a default value is set inside and a checker for nil to make sure it is only allocated once
- (NSURL *)xmlURL
{
    if (!_xmlURL) {
        _xmlURL = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/101222705/business.xml"];
    }
    
    return _xmlURL;
}

#pragma mark - Initialisation
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

//initial setup of the controller
//it is called inside the viewDidAppear Method to make sure that all view objects are allocated first before doing any setup
- (void)initialSetup
{
    NSXMLParser *xmlInformationParser = [[NSXMLParser alloc] initWithContentsOfURL:self.xmlURL];
    xmlInformationParser.delegate = self;
    [xmlInformationParser parse];
}

#pragma mark - UI Lyfecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self initialSetup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"business"]) {
        
        [self.currentSection addObject:elementName];
        [self.sectionObjects addObject:elementName];
        
    } else if ([elementName isEqualToString:@"location"]) {
        
        [self.currentSection addObject:elementName];
        [self.sectionObjects addObject:elementName];
        
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [self.xmlCurrentValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"business"]) {
        
        [self.currentSection removeObject:elementName];
        
    } else if ([elementName isEqualToString:@"location"]) {
        
        [self.currentSection removeObject:elementName];
   
        
    } else if ([self.currentSection.lastObject isEqualToString:@"business"]) {
        
        self.xmlInformationDictionary[elementName] = self.xmlCurrentValue;
        self.xmlCurrentValue = nil;
        
    } else if ([self.currentSection.lastObject isEqualToString:@"location"]) {
        
        self.xmlLocationDictionary[elementName] = self.xmlCurrentValue;
        self.xmlCurrentValue = nil;
        
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.sectionObjects addObject:@"Map"];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.sectionObjects count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSString *elementName = self.sectionObjects[section];
    // Return the number of rows in the section.
    if ([elementName isEqualToString:@"business"] || [elementName isEqualToString:@"location"]) {
        return [[[self getDictionaryObjectForSection:section] allKeys] count];
    } else if ([elementName isEqualToString:@"Map"]) {
        return 1;
    } else {
        return 0;
        
    }
    
}

- (NSMutableDictionary *)getDictionaryObjectForSection:(NSInteger)section
{
    NSString *elementName = self.sectionObjects[section];
    
    if ([elementName isEqualToString:@"business"]) {
        return self.xmlInformationDictionary;
    } else if ([elementName isEqualToString:@"location"]){
        return self.xmlLocationDictionary;
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier;
    UITableViewCell *cell;
    NSString *elementName = self.sectionObjects[indexPath.section];
    if ([elementName isEqualToString:@"business"] || [elementName isEqualToString:@"location"]) {
        CellIdentifier = informationIdentifier;
    } else if ([elementName isEqualToString:@"Map"]) {
        CellIdentifier = businessLocationIdentifier;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell = [self configureTableViewCellForCell:cell andIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *elementName = self.sectionObjects[indexPath.section];
    if ([elementName isEqualToString:@"Map"]) {
        return 150;
    } else {
        return 44;
    }
}

- (UITableViewCell *)configureTableViewCellForCell:(UITableViewCell *)passedTableViewCell andIndexPath:(NSIndexPath *)indexPath
{
    NSString *elementName = self.sectionObjects[indexPath.section];
    
    NSDictionary *currentSectionObjects = [self getDictionaryObjectForSection:indexPath.section];
    if ([elementName isEqualToString:@"business"] || [elementName isEqualToString:@"location"]) {
        
        XMLInformationTableViewCell *cell = (XMLInformationTableViewCell *)passedTableViewCell;
        
        if (currentSectionObjects.allKeys.count <= indexPath.row) {
            
        } else if (!currentSectionObjects.allKeys[indexPath.row]) {
            
        } else if ([currentSectionObjects.allKeys[indexPath.row] isEqualToString:@""]) {
            
        } else {
            
            UIImageView *imageView = cell.image;
            
            imageView.tag = 3;
            
            cell.informationTitleLabel.text = currentSectionObjects.allKeys[indexPath.row];
            
            cell.informationValueLabel.text = currentSectionObjects[cell.informationTitleLabel.text];
            
        }
        
        return cell;
        
    } else if ([elementName isEqualToString:@"Map"]){
        
        XMLLocationTableViewCell *cell = (XMLLocationTableViewCell *)passedTableViewCell;
        
        currentSectionObjects = [self getDictionaryObjectForSection:indexPath.section-1];
        
        NSNumber *longitude = [NSNumber numberWithDouble:[currentSectionObjects[@"longitude"] doubleValue] ];
        
        NSNumber *latitude = [NSNumber numberWithDouble:[currentSectionObjects[@"latitude"] doubleValue] ];
        
        MKPointAnnotation *locationPointAnnotation = [[MKPointAnnotation alloc] init];
        
        CLLocationCoordinate2D locationCoordinate;
        locationCoordinate.latitude = [latitude doubleValue];
        locationCoordinate.longitude = [longitude doubleValue];
        
        [locationPointAnnotation setCoordinate:locationCoordinate];
        [locationPointAnnotation setTitle:@"BusinessLocation"];
        
        [cell.mapView addAnnotation:locationPointAnnotation];
        MKCoordinateSpan span = MKCoordinateSpanMake(0.20, 0.20);
        MKCoordinateRegion region = MKCoordinateRegionMake(locationCoordinate, span);
        
        
        
        [cell.mapView setRegion:region animated:YES];
        
        return cell;
    } else {
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionObjects[section];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
