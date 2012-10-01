#import "EntriesController.h"
#import "DataManager.h"

@implementation EntriesController

@synthesize managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize searchResults;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  NSLog(@"seque: %@", segue.identifier);
  
  if([segue.identifier isEqualToString:@"AddEntry"]){
    UINavigationController *nv = (UINavigationController *)[segue destinationViewController];
    EditEntryController *addEntryController = (EditEntryController *)nv.topViewController;
    addEntryController.delegate = self;
    addEntryController.managedObjectContext = self.managedObjectContext;
  } else if([segue.identifier isEqualToString:@"EditEntry"]){
    EditEntryController *eec = (EditEntryController *)[segue destinationViewController];
    eec.delegate = self;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    eec.entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    eec.managedObjectContext = self.managedObjectContext;
  } else if([segue.identifier isEqualToString:@"Settings"]){
    SettingsController *sc = (SettingsController *)[segue destinationViewController];
    sc.delegate = self;      
  }
}

- (void)settingsDone
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) editEntryController:(EditEntryController *)eec addEntry:(Item *)entry
{
  [self.tableView reloadData];
  [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) editEntryController:(EditEntryController *)eec updateEntry:(Item *)entry 
{
  [self.tableView reloadData];
  [[self navigationController] popViewControllerAnimated:YES];
}

-(void) cancelEdit:(EditEntryController *)eec
{
  NSLog(@"trying to cancel edit");
  [self dismissViewControllerAnimated:YES completion:nil];
  [[self navigationController] popViewControllerAnimated:YES];
}

- (NSFetchedResultsController *)fetchedResultsController {
  
  if (_fetchedResultsController == nil) {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" 
                                              inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"delete_status == 0"]];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
  
    [fetchRequest setFetchBatchSize:20];
  
    NSFetchedResultsController *theFetchedResultsController =
        [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                            managedObjectContext:managedObjectContext 
                                              sectionNameKeyPath:nil
                                                       cacheName:nil];
                                                       //cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
  }
    
  return _fetchedResultsController;
  
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.searchResults =
      [NSMutableArray arrayWithCapacity:[[self.fetchedResultsController fetchedObjects] count]];
  NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}

- (void)viewDidUnload
{
  //[self setSearchResultsController:nil];
  [super viewDidUnload];
  self.searchResults = nil;
  self.fetchedResultsController = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    return [self.searchResults count];
  } else {
    id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
  }
}

- (NSString *)formatTitle:(NSString *)text
{
  NSString *trimmed =
      [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSArray *lines =
      [trimmed componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
  return [lines objectAtIndex:0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"EntryCell";
  UITableViewCell *cell =
      [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];

  static NSDateFormatter *dateFormatter = nil;
  if (dateFormatter == nil) {  
    dateFormatter = [[NSDateFormatter alloc] init];  
    [dateFormatter setDateFormat:@"MM/dd h:mm a"];  
  } 
  Item *item;

  if (tableView == self.searchDisplayController.searchResultsTableView) {
    item = [self.searchResults objectAtIndex:indexPath.row];
  } else {
    item = [_fetchedResultsController objectAtIndexPath:indexPath];
  }

  cell.textLabel.text = [self formatTitle:item.text];
  cell.detailTextLabel.text = [dateFormatter stringFromDate:item.date];

  return cell;
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
  
  UITableView *tableView = self.tableView;
  
  switch(type) {
      
    case NSFetchedResultsChangeInsert:
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeUpdate:
      [tableView reloadData]; // ?? this seems brutish, no?
      break;
      
    case NSFetchedResultsChangeMove:
      [tableView deleteRowsAtIndexPaths:[NSArray
                                         arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths:[NSArray
                                         arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
  
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  // The fetch controller has sent all current change notifications, so tell
  // the table view to process all updates.
  [self.tableView endUpdates];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  // The specified item is not editable.
  return NO;
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	[self.searchResults removeAllObjects];
	for (Item *item in [self.fetchedResultsController fetchedObjects]) {
		if ([scope isEqualToString:@"All"] || [item.text isEqualToString:scope]) {
			NSComparisonResult result = [item.text compare:searchText
                                             options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)
                                               range:NSMakeRange(0, [searchText length])];
      if (result == NSOrderedSame) {
				[self.searchResults addObject:item];
      }
		}
	}
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
    shouldReloadTableForSearchString:(NSString *)searchString
{
  [self filterContentForSearchText:searchString scope:@"All"];
  return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
    shouldReloadTableForSearchScope:(NSInteger)searchOption
{
  [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:@"All"];
  return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Using storyboard.
}

@end
