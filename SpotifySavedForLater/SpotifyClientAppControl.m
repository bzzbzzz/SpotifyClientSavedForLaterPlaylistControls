//
//  SpotifyControl.m
//  SimplePlayer
//
//  Created by Felix Vigl on 31.03.13.
//  Copyright (c) 2013 Spotify. All rights reserved.
//

#import "SpotifyClientAppControl.h"

@implementation SpotifyClientAppControl

//TODO: read up on obj-c blocks memory stuff and scripting bridge and decide where property is needed or simple var in method scope is allright

- (SpotifyApplication *)spotify
{
	
if (!_spotify) _spotify = [SBApplication applicationWithBundleIdentifier:@"com.spotify.client"];
if (_spotify) if (![_spotify isRunning]) _spotify = nil;

return _spotify;
	
}

- (NSURL *)currentTrackSpotifyURL
{
	if (!_currentTrackSpotifyURL) _currentTrackSpotifyURL = [[NSURL alloc] init];
	_currentTrackSpotifyURL = [NSURL URLWithString:[[self.spotify currentTrack] spotifyUrl]];
	return _currentTrackSpotifyURL;
}


- (void)nextTrack	{	[self.spotify nextTrack];	}


- (void)starCurrentTrackinSession:(SPSession *)session
{		
	
	if (!self.currentTrackSpotifyURL.absoluteString.length) return;
	
	[SPTrack trackForTrackURL:self.currentTrackSpotifyURL inSession:session callback: ^(SPTrack *track){
		//TODO: not sure if needed again:
		[SPAsyncLoading waitUntilLoaded:track timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
			[track setStarred:YES];
			[self removeTrack:track fromPlalistinSession:session];
		} ];
		
		
	}];
		 
}

- (void)removeCurrentTrackFromPlaylistAndPlayNextinSession:(SPSession *)session
{
	
	if (!self.currentTrackSpotifyURL.absoluteString.length) return;
	
	[SPTrack trackForTrackURL:self.currentTrackSpotifyURL inSession:session callback: ^(SPTrack *track){
		
		[SPAsyncLoading waitUntilLoaded:track timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
			self.trackToRemove = track;
			[self.spotify nextTrack];
			[self removeTrack:self.trackToRemove fromPlalistinSession:session];
		} ];
		
		
	}];
	
}

//TODO: get playlist URL from NSUserDefaults (set with playlist PopUpButton) instead of 1st one named testPlaylist
//TODO: Use track's URL instead of SPTrack as argument
- (void)removeTrack:(SPTrack *)trackToRemove fromPlalistinSession:(SPSession *)session
{
	NSLog(@"track to remove: %@ ",trackToRemove.name);
	SPPlaylistContainer *userPlaylists = session.userPlaylists;
	__block BOOL trackWasFound = NO;
	[SPAsyncLoading waitUntilLoaded:userPlaylists timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
		if (!notLoadedItems.count) {
			
			self.playlist = userPlaylists.playlists[0];
				
				[SPAsyncLoading waitUntilLoaded:self.playlist timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
					if (!notLoadedItems.count) {
						
						if ([self.playlist.name isEqualToString:@"testPlaylist"]) {
							NSLog(@"found testPlaylist");
							
							for (NSUInteger index = 0; index < self.playlist.items.count ; index++) {
								SPPlaylistItem *playlistItem = self.playlist.items[index];
								if (playlistItem.itemClass == [SPTrack class]) {
									SPTrack *track = playlistItem.item;
									
									[SPAsyncLoading waitUntilLoaded:track timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
										if (!notLoadedItems.count) {
											if ([track.spotifyURL isEqualTo:trackToRemove.spotifyURL]) {
												NSLog(@"%@ found at index %lu!",track.name, index);
												trackWasFound = YES;
												self.track = track;
												[self.playlist removeItemAtIndex:index callback:^(NSError *error) {
													if (error) { NSLog(@"error removing track: %@ at index %lu :%@", track.name, index, error.localizedDescription);
													} else {
														NSLog(@"successfully removed track: %@ at index %lu", track.name, index);
													}
													[NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:3.0];
													return;
												}];
											} else if ( (index == self.playlist.items.count -1) && !trackWasFound ) {
												NSLog(@"%@ not found in playlist %@",track.name ,self.playlist.name);
												[NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:3.0];
											}
										}
									}];
								}
							}
							
						}
					}
				}];
			
		}
	}];
	
}


- (void)newSavedForLaterPlaylist
{
	/** Create a new, empty playlist.
	 
	 @param name The name of the new playlist. Must be shorter than 256 characters and not consist of only whitespace.
	 @param block The callback block to call when the operation is complete.
	 */
	//-(void)createPlaylistWithName:(NSString *)name callback:(void (^)(SPPlaylist *createdPlaylist))block;

}

@end