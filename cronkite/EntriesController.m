#import "EntriesController.h"
#import "DataManager.h"

@implementation EntriesController

@synthesize managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if([segue.identifier isEqualToString:@"AddEntry"]){
    UINavigationController *nv = (UINavigationController *)[segue destinationViewController];
    EditEntryController *ntvc = (EditEntryController *)nv.topViewController;
    ntvc.delegate = self;
  } else if([segue.identifier isEqualToString:@"EditEntry"]){
    EditEntryController *eec = (EditEntryController *)[segue destinationViewController];
    eec.delegate = self;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    eec.entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
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
  [entry setSync_status:[NSNumber numberWithInt:1]];
  NSError *error;
  if(![managedObjectContext save:&error]){
    NSLog(@"ERROR updating item");
  }
  [self.tableView reloadData];
  [[self navigationController] popViewControllerAnimated:YES];
}

-(void) cancelEdit:(EditEntryController *)eec
{
  [self dismissViewControllerAnimated:YES completion:nil];
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
  NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}

- (void)viewDidUnload
{
  [super viewDidUnload];
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
  id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
  return [sectionInfo numberOfObjects];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

  static NSDateFormatter *dateFormatter = nil;   
  if (dateFormatter == nil) {  
    dateFormatter = [[NSDateFormatter alloc] init];  
    [dateFormatter setDateFormat:@"MM/dd h:mm a"];  
  } 
  
  Item *entry = [_fetchedResultsController objectAtIndexPath:indexPath];
  cell.textLabel.text = entry.text;
  cell.detailTextLabel.text = [dateFormatter stringFromDate:[entry date]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"EntryCell";
  UITableViewCell *cell =
  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  [self configureCell:cell atIndexPath:indexPath];
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
      [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
