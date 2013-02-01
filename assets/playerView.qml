import bb.cascades 1.0

import bb.multimedia 1.0

Page {
    id: pgPlayer
    
    Container {
        id: appContainer
        background: Color.create("#ff262626")
        
        layout: DockLayout {
        }
        
        //This variable is used to control video duration logic. 
        //Indicates whether to change the video position, when the slider's value is changed.
        property bool changeVideoPosition : true
        
        // This properties are used for dynamically defining video window size for different orientations
        property int landscapeWidth : 1280
        property int landscapeHeight : 768
        
        property int touchPositionX: 0
        property int touchPositionY: 0
        property bool playerStarted: false
        
        Container {
            id: contentContainer
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Bottom
            
            layout: DockLayout {}
            
	        preferredWidth:  appContainer.landscapeWidth
	        preferredHeight: appContainer.landscapeHeight 
	        
	        onTouch: {
	        	if (event.touchType == TouchType.Down)
	        	{
	        	     appContainer.touchPositionX =  event.localX;
	        	     appContainer.touchPositionY =  event.localY;
	            }
	            else if (event.touchType == TouchType.Up)
	            {
	                if (appContainer.touchPositionX  > event.localX + 30) {
	                     appContainer.changeVideoPosition = true;
	                     if (durationSlider.immediateValue + 5000/myPlayer.duration < 1) {
	                         durationSlider.setValue(durationSlider.immediateValue + 5000/myPlayer.duration);
	                     } else {
	                         durationSlider.setValue(1);
	                         myPlayer.pause();
	                     }
	                } else if (appContainer.touchPositionX + 30  < event.localX) {
	                     appContainer.changeVideoPosition = true;
	                     durationSlider.setValue(durationSlider.immediateValue - 5000/myPlayer.duration);
	                } else {
	                       if(myPlayer.mediaState != MediaState.Started) {
	                        	appContainer.playMediaPlayer();
	                            screenPlayImage.setOpacity(0.5)
	                            screenPauseImage.setOpacity(0)
	                            screenPlayImageTimer.start()
	                        } else {
	                            appContainer.pauseMediaPlayer();
	                            screenPauseImage.setOpacity(0.5)
	                            screenPlayImage.setOpacity(0)
	                            screenPauseImageTimer.start()
	                        }
	                 }
	            }
	        }
            
	        ForeignWindowControl {
                id: videoWindow
                objectName: "VideoWindow"
                windowId: "VideoWindow"
	                
				gestureHandlers: [
				]
				    				    
	            preferredWidth:  appContainer.landscapeWidth
	            preferredHeight: appContainer.landscapeHeight 
	            updatedProperties:// WindowProperty.SourceSize | 
	                WindowProperty.Size |
	                WindowProperty.Position |
	                WindowProperty.Visible                
	                
	            onVisibleChanged: {
	                console.log("foreignwindow visible = " + visible);
	            }
	            onBoundToWindowChanged: {
	                console.log("VideoWindow bound to mediaplayer!");
	            }
	        } //videoWindow

            // Play image is transparent. It will become visible when the video
            // is played using tap event. It will be visible 1 sec.
            ImageView {
                id: screenPlayImage
                opacity: 0
                imageSource: "asset:///images/screenPlay.jpg"
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                touchPropagationMode: TouchPropagationMode.PassThrough
                overlapTouchPolicy: OverlapTouchPolicy.Allow
            }
   
            // Pause image is transparent. It will become visible when the video
            // is paused using tap event. It will be visible 1 sec.
            ImageView {
                id: screenPauseImage
                opacity: 0
                imageSource: "asset:///images/screenPause.jpg"
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                touchPropagationMode: TouchPropagationMode.PassThrough
                overlapTouchPolicy: OverlapTouchPolicy.Allow
            }
          
            Container
            {
                id: controlsContainer
                layout: StackLayout {
                    orientation: LayoutOrientation.TopToBottom
                }
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Bottom

	            Container {
	                id: sliderContainer
	                objectName: sliderContainer

	                layout: StackLayout {
	                    orientation: LayoutOrientation.LeftToRight
	                }
	                
	                leftPadding: 5
	                rightPadding: 5
	                horizontalAlignment: HorizontalAlignment.Fill
	                verticalAlignment: VerticalAlignment.Bottom
	            
	            
	                Label {
	                    id: currentTime
	                    // the "text" will be set when media plays
	                    text: "00:00:00"
	                    textStyle {
	                        color: Color.White
	                        fontWeight: FontWeight.Normal
	                    }
	                    preferredWidth: 150
                        horizontalAlignment: HorizontalAlignment.Left
                        verticalAlignment: VerticalAlignment.Center
	                } // currentTimeLabel
	
	                Slider {
	                    id: durationSlider
	                    objectName: durationSlider
	                    leftMargin: 5
	                    rightMargin: 5
	                    fromValue: 0.0
	                    toValue: 1.0
	                    enabled: false
	                    horizontalAlignment: HorizontalAlignment.Fill
	                    verticalAlignment: VerticalAlignment.Center
	                    
	                    layoutProperties: StackLayoutProperties {
	                        spaceQuota: 1
	                    }
	                    onTouch: {
	                        if (event.touchType == TouchType.Down) {  
	                            if(myPlayer.mediaState == MediaState.Started) {
	                        	     myPlayer.pause();
	                        	     appContainer.playerStarted = true;
	                        	 }
	                        } else if (event.touchType == TouchType.Up) {                	             
	                            if(appContainer.playerStarted == true) {
	                                if ( appContainer.playerStarted == true) {
	                                    myPlayer.play();
	                        	       	appContainer.playerStarted = false;
	                        	    }
	                            }
	                        }
	                    }
	                    onImmediateValueChanged: {
	                        if(myPlayer.mediaState == MediaState.Started ||
	                            myPlayer.mediaState == MediaState.Paused) {
	                                if(appContainer.changeVideoPosition == true) {
	                                    myPlayer.seekPercent(durationSlider.immediateValue);
	                                }
	                        }
	                    }
	                } //durationSlider
	                
	                Label {
	                    id: totalTime
	                    // the "text" will be set when media plays
	                    text: "00:00:00"
	                    preferredWidth: 150
	                    textStyle {
	                        color: Color.White
	                        fontWeight: FontWeight.Normal
	                    }
                        horizontalAlignment: HorizontalAlignment.Right
                        verticalAlignment: VerticalAlignment.Center
	                } // totalTimeLabel

	                
	                
                }//sliderContainer
                                         
	            Container {
	                id: buttonContainer
	                objectName: buttonContainer
	                
	                opacity: 0.5

	                layout: StackLayout {
	                    orientation: LayoutOrientation.LeftToRight
	                }
	                
                
	                leftPadding: 40
	                rightPadding: 40
	                horizontalAlignment: HorizontalAlignment.Center
	                verticalAlignment: VerticalAlignment.Bottom
	                
	                ImageButton {
	                    id:backButton
	                    defaultImageSource: "asset:///images/back.png"
	                    
	                    onClicked:{
	                        myPlayer.stop();
                            navigationPane.pop();
                            pgPlayer.destroy();
	                    }
	                }
	                
	                ImageButton {
	                    id:previousButton
	                    defaultImageSource: "asset:///images/previous.png"
	                    
	                    onClicked:{
	                        myPlayer.stop()
	                        myPlayer.setSourceUrl(myListModel.getPreviousVideoPath())
	                        if (appContainer.playMediaPlayer() == MediaError.None) {
	                          videoWindow.visible = true;
	                          contentContainer.visible = true;
	                          durationSlider.resetValue()
	                          durationSlider.setEnabled(true)
	                          trackTimer.start();
	                        }
	                    }
	                }
	                
	                ImageButton {
	                    id:playButton
	                    defaultImageSource: "asset:///images/play.png"
	                    
	                    onClicked:{
	                        if(myPlayer.mediaState == MediaState.Started) {
	                            appContainer.pauseMediaPlayer();
	                        }
	                        else if(myPlayer.mediaState == MediaState.Paused) {
	                            appContainer.playMediaPlayer();
	                        }
	                        else {
	                            myPlayer.setSourceUrl(myListModel.getSelectedVideoPath())
	                            
	                            if (appContainer.playMediaPlayer() == MediaError.None) {
	                                videoWindow.visible = true;
	                                contentContainer.visible = true;
	                                durationSlider.setEnabled(true)
	                                durationSlider.resetValue()
	                                trackTimer.start();
	                            }
	                        }
	                    }
	                }
	                
	                ImageButton {
	                    id:nextButton
	                    defaultImageSource: "asset:///images/next.png"
	                    opacity: 0.5
	                    
	                    onClicked:{
	                        myPlayer.stop();
	                        myPlayer.setSourceUrl(myListModel.getNextVideoPath())
	                        if (appContainer.playMediaPlayer() == MediaError.None) {
	                          videoWindow.visible = true;
	                          contentContainer.visible = true;
	                          durationSlider.resetValue()
	                          durationSlider.setEnabled(true)
	                          trackTimer.start();
	                        }
	                    }
	                }
	                
/*	                ImageButton {
	                    id:muteButton
	                    text: "Mute"
	                    
	                    onClicked:{}
	                }
	                
	                Slider {
	                    id: volumeSlider
	                    objectName: volumeSlider
	                    leftMargin: 20
	                    rightMargin: 20
	                    fromValue: 0.0
	                    toValue: 1.0
	                    enabled: true
	                    horizontalAlignment: HorizontalAlignment.Fill
	                    verticalAlignment: VerticalAlignment.Center
	                    
	                    preferredWidth: 500
	                    
	                    layoutProperties: StackLayoutProperties {
	                        spaceQuota: 1
	                    }
	                    onImmediateValueChanged: {
	                        //TODO change the system volume
	                    }
	                } //volumeSlider
*/	               
	            }//buttonContainer
                
            }//controlsContainer
            
        }//contentContainer
        
        function playMediaPlayer() {
            playButton.setDefaultImageSource("asset:///images/pause.png");            
            return myPlayer.play();
        }

        function pauseMediaPlayer() {
            playButton.setDefaultImageSource("asset:///images/play.png");            
            return myPlayer.pause();
        }

        attachedObjects: [
            Sheet {
                id: videoSheet
                objectName: "videoSheet"
                content:Page {
                   
                    
                }
            },
               
               
           MediaPlayer {
               id: myPlayer
               // Use the device's primary display to
               // show the video.
               videoOutput: VideoOutput.PrimaryDisplay
               
               // The ID of the ForeignWindow control to
               // use as the rendering surface.
               windowId: "VideoWindow"

               onPositionChanged: {
                   currentTime.text = myListModel.getFormattedTime(position)
               }
               onDurationChanged: {
                   totalTime.text = myListModel.getFormattedTime(duration)
               }
               
               // Investigate how the metadata can be retrieved without playing the video.
               onMetaDataChanged: {
                    console.log("player onMetaDataChanged");
                    console.log("--------------------------------bit_rate=" + myPlayer.metaData.bit_rate);
                    console.log("-----------------------------------genre=" + myPlayer.metaData.genre);
                    console.log("-----------------------------sample_rate=" + myPlayer.metaData.sample_rate);
                    console.log("-----------------------------------title=" + myPlayer.metaData.title);
                }
               
           },
           
           QTimer {
               id: trackTimer
               singleShot: false
               //Investigate why the onTimeout is called after 1000 msec
               interval: 500
               onTimeout: {
		           if(myPlayer.mediaState == MediaState.Started) {
		               appContainer.changeVideoPosition = false;
		               durationSlider.setValue(myPlayer.position / myPlayer.duration)
		               appContainer.changeVideoPosition = true;
		           }
		           else if(myPlayer.mediaState == MediaState.Stopped) {
		               appContainer.changeVideoPosition = false;
		               durationSlider.setValue(durationSlider.toValue)
		               appContainer.changeVideoPosition = true;		                
		               trackTimer.stop();
		           }
		       }
           },
           
           QTimer {
               id: screenPlayImageTimer
               singleShot: true
               interval: 1000
               onTimeout: {
                   screenPlayImage.setOpacity(0)
                   screenPlayImageTimer.stop()
		       }
           },
           
           QTimer {
               id: screenPauseImageTimer
               singleShot: true
               interval: 1000
               onTimeout: {
                   screenPauseImage.setOpacity(0)
                   screenPauseImageTimer.stop()
		       }
           },
           
           OrientationHandler {
               onOrientationAboutToChange: {
                   if (orientation == UIOrientation.Landscape) {
                       videoWindow.preferredWidth = appContainer.landscapeWidth
                       videoWindow.preferredHeight = appContainer.landscapeHeight
                   } else {
                       videoWindow.preferredWidth = appContainer.landscapeHeight
                       videoWindow.preferredHeight = (appContainer.landscapeHeight * appContainer.landscapeHeight) / appContainer.landscapeWidth
                   }
               }
           }
           
        ] // Attached objects.
    
	    onCreationCompleted: {
	        OrientationSupport.supportedDisplayOrientation =
	            SupportedDisplayOrientation.All;
	            
            if (OrientationSupport.orientation == UIOrientation.Landscape) {
                videoWindow.preferredWidth = appContainer.landscapeWidth
                videoWindow.preferredHeight = appContainer.landscapeHeight
                
            } else {
                videoWindow.preferredWidth = appContainer.landscapeHeight
                videoWindow.preferredHeight = (appContainer.landscapeHeight * appContainer.landscapeHeight) / appContainer.landscapeWidth
                
            }
        }

    }//appContainer
}// Page