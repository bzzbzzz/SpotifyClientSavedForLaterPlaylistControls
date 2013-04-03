//
//  SpotifyControl.h
//  SimplePlayer
//
//  Created by Felix Vigl on 31.03.13.
//  Copyright (c) 2013 Spotify. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ScriptingBridge/SBApplication.h>
#import "Spotify.h"
#import <CocoaLibSpotify/CocoaLibSpotify.h>

@interface SpotifyClientAppControl : NSObject

@property (nonatomic, strong) SpotifyApplication *spotify;
@property (nonatomic, strong) NSURL *currentTrackSpotifyURL;
@property (nonatomic, strong) SPTrack *track;
@property (nonatomic, strong) SPTrack *trackToRemove;
@property (nonatomic, strong) SPPlaylist *playlist;
@property (nonatomic, strong) NSArray *arrayOfPlaylistsItems;

- (void)starCurrentTrackinSession:(SPSession *)session;
- (void)removeCurrentTrackFromPlaylistAndPlayNextinSession:(SPSession *)session;

- (void)nextTrack;

- (void)newSavedForLaterPlaylist;

@end
