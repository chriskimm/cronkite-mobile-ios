#import "EntriesController.h"

@implementation EntriesController

@synthesize managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if([segue.identifier isEqualToString:@"AddEntry"]){
    UINavigationController *nv = (UINavigationController *)[segue destinationViewController];
    EditEntryController *ntvc = (EditEntryController *)nv.topViewController;
    ntvc.delegate = self;
  } else if([segue.identifier isEqualToString:@"EditEntry"]){
    EditEntryController *eec = (EditEntryController *)[segue destinationViewController];
    eec.delegate = self;    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    eec.entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
  }
}

-(void) editEntryController:(EditEntryController *)eec addEntry:(Entry *)entry
{
  Entry *newEntry = (Entry *)[NSEntityDescription insertNewObjectForEntityForName:@"Entry" 
                                                           inManagedObjectContext:managedObjectContext];  
  newEntry.text1 = [entry text1];
  newEntry.date = [NSDate date];

  NSError *error;
  if(![managedObjectContext save:&error]){
    NSLog(@"ERROR saving entry");
  }

  [self.tableView reloadData];
  [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) editEntryController:(EditEntryController *)eec updateEntry:(Entry *)entry 
{
  NSError *error;
  [managedObjectContext save:&error];
  [self.tableView reloadData];
  [[self navigationController] popViewControllerAnimated:YES];
}

-(void) editEntryController:(EditEntryController *)eec deleteEntry:(Entry *)entry 
{
  [self.tableView beginUpdates]; // Avoid  NSInternalInconsistencyException
  //NSLog(@"Deleting (%@)", roleToDelete.name);
  [self.managedObjectContext deleteObject:entry];
  [self.managedObjectContext save:nil];
  
  // Delete the (now empty) row on the table
  //[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
  [self.tableView reloadData];
  [self.tableView endUpdates];
  [[self navigationController] popViewControllerAnimated:YES];
}

-(void) cancelEdit:(EditEntryController *)eec
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSFetchedResultsController *)fetchedResultsController {
  
  if (_fetchedResultsController == nil) {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" 
                                              inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
  
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
  
    [fetchRequest setFetchBatchSize:20];
  
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:managedObjectContext 
                                          sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
  }
    
  return _fetchedResultsController;
  
}

- (void) allEntries
{
  // Define our table/entity to use
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" 
                                            inManagedObjectContext:managedObjectContext];
    
  // Setup the fetch request
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:entity];
    
  // Define how we will sort the records
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
  NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
  [request setSortDescriptors:sortDescriptors];
    
  // Fetch the records and handle an error
  NSError *error;
  NSMutableArray *mutableFetchResults = 
        [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
  if (!mutableFetchResults) {
    NSLog(@"Error fetching results");
    // Handle the error.
  }
  
  // Hackage!! Figure out what's up with lazy-loading
  for (Entry *entry in mutableFetchResults) {
    NSLog(@"text: %@", entry.text1);
    NSLog(@"date: %@", entry.date);
  }
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
    [dateFormatter setDateFormat:@"h:mm.ss a"];  
  } 
  
  Entry *entry = [_fetchedResultsController objectAtIndexPath:indexPath];
  cell.textLabel.text = entry.text1;
  cell.detailTextLabel.text = [dateFormatter stringFromDate:[entry date]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *cellIdentifier = @"EntryCell";
  UITableViewCell *cell =
  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  [self configureCell:cell atIndexPath:indexPath];
  return cell;
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"EntryCell";
  
  static NSDateFormatter *dateFormatter = nil;   
  if (dateFormatter == nil) {  
    dateFormatter = [[NSDateFormatter alloc] init];  
    [dateFormatter setDateFormat:@"h:mm.ss a"];  
  }  
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];   
  
  if (cell == nil) {  
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];  
  }   
  
  Entry *entry = [self.entries objectAtIndex: [indexPath row]];  
  NSLog(@"row a: %@", entry.text1);
  NSLog(@"row b: %@", [entry text1]);
  [cell.textLabel setText:[entry text1]];
  [cell.detailTextLabel setText:[dateFormatter stringFromDate:[entry date]]];
  
  return cell; 
}
*/

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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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