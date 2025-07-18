# UTURNs
## Layman Summary:
  I’m searching for the factors that drive cellular decision making in tightly packed groups of cells that migrate together in response to an external cue. This information may lead to a better understanding of how to control cells for purposes like healing and tissue engineering. To do this, I grow small tissues of dog kidney cells, which can sense and migrate along the direction of an electric field, and analyze the tracks of individual cells as they respond to a reversal of field direction. When these cells sense a field reversal, different clusters in the same tissue make wide U-shaped turns in left or right handed directions in order to turn around and re-align with the new field direction. I’m looking to discover how and why turn direction is decided on a group scale, and ultimately, whether it can be controlled.

## UTURN Experiment:
- sample preparation:

I seed* MDCK cells into PDMS stencils on plastic tissue culture dishes (sometimes treated with collagen to facilitate cell attachment), and allow them to attach to the substrate for 1hr (30-45m for collagen) before flooding it with media. The cells proliferate overnight (~16-18hr) in the incubator until confluent within the stencil. In the morning, I pull the stencil away to allow the edges of the tissue to relax and begin to expand while I set up the experiment (~1-2.5hr before imaging begins). When materials are prepared, perfusion media is CO2 treated, etc, I assemble the CORGI, a 2-electrode version of the (SCHEEPDOG)[http://pmc.ncbi.nlm.nih.gov/articles/PMC7779114/]. The tissues are aligned with their long axes perpendicular to the direction of the field.*
- stimulation:
  
I attach the CORGI to a programmable power source created by Yubin Lin to apply 0mA for 20 minutes, 9mA for 90 minutes, -9mA for 180 minutes, and 0mA for 60 minutes to achieve order 3V/cm field across the sample.
- imaging:
  
I set up imaging at 10x magnification in phase contrast, using stitching to capture each tissue fully. I capture every 2.5 minutes.
- image processing:
  
After the experiment, I rotate each image as needed to align the tissue and E field bases (which should be aligned during assembly) with the image xy basis and crop to remove background. 
- - cellpose:
    
  I segment each image using cellpose, which identifies the boundaries of each cell with a high accuracy- especially among cells with bright, mature junctions. Currently, I'm using the CPSAM model with no additional training.
  - trackmate:
    
  I feed the label images (in which the background is value 0 and each cell is assigned an integer value (1,2,...)) produced by cellpose to the TrackMate plugin in FIJI and use the Simple LAP tracker with gap closing and linking distances set to 10px and max frame gap set to 3 frames.* Trackmate calculate tracks (which may be discontinuous for any given cell due to tracking/segmentation errors), spot and edge features (characteristics of the cell label, eg area, orientation, shape index), and track features (max speed, distance travelled, etc), which can be exported for analysis. 
- analysis goals/steps:
  
- - identify up vs down turns:
    
  - - The most critical step in the analysis is classifying tracks as up or down turns. There are plenty of ways to do this. Currently, I'm taking only a portion or the track around the time it switches direction (the pivots), splining the data, splitting the curve into before and after the peak/apex of the turn, and then taking the sign of the difference between the areas under each half of the curve. I'm open to creative alternatives that are more consistent/well motivated/faster/etc.
  - identify turning domains:
    
  - - Once cells have been classified as up/down, I want to cluster them to identify domains which have some collective relationship to one another so that I can learn about how they form. Currently, I'm trying to build a script to use my up/down classification to mask the label images, then use a watershed algorithm to separate connected components of just the up labels/just the down labels. If this is possible, it will be simple to then pull cell number, cell area distributions vs domain areas, etc (individual and local and global data).
  - - characterize turning domains
    - - cell number
      - correlation length
      - proportions/symmetry
  - identify predictive factors
  - - turn width
    - salient neighbors
    - speed

  ## Current Useful Scripts in this Repository
  - **TracksForm**: format tracks, filter out very short track fragments
  - **Hairball**: create hairball plot of cell tracks
  - **Pivots**: isolate the pivot section of cell tracks
  - **gifMark**: plot tracks onto original image for visualization purposes
  - **UDgifMark2**: plot like gifMark but tracks are color coded up/down
  - **TilePlot**: plot a tiled layout of tracks
