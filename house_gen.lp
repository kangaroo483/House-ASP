  % Modeled after terrain_type(grass;tree;flower;water;bridge) in example code %
  construction_type(door; wall; floor; bed).

  % Modeled after immediate_neighbors(XX,YY,TYPE,COUNT) in example code %
	immediate_neighbors_construction(X, Y, CONSTRUCTION_TYPE, COUNT) :- 
      COUNT = {construction(X, Y-1, CONSTRUCTION_TYPE);
               construction(X-1, Y, CONSTRUCTION_TYPE);
               construction(X+1, Y, CONSTRUCTION_TYPE);
               construction(X, Y+1, CONSTRUCTION_TYPE)},
      construction(X, Y, _),					
      construction_type(CONSTRUCTION_TYPE).

  % CONSTRAINT #1: Build a house using 1 door, 1 bed, 15 wall, 8 floor 
  1 {construction(X, Y, door) : width(X), height(Y)} 1.
  1 {construction(X, Y, bed) : width(X), height(Y)} 1.
  15 {construction(X, Y, wall) : width(X), height(Y)} 15.
  8 {construction(X, Y, floor) : width(X), height(Y)} 8.

  % CONSTRAINT #2: No doors may be built horizontally adjacent
  :- construction(X, Y, door), construction(X-1, Y, door; X+1, Y, door).

  % CONSTRAINT #3: No doors may be in corners
  :- construction(X, Y, door), X = 1, Y = 1.
  :- construction(X, Y, door), X = 1, Y = max_height.
  :- construction(X, Y, door), X = max_width, Y = 1.
  :- construction(X, Y, door), X = max_width, Y = max_height.

  % CONSTRAINT #4: No doors may be built if an immediate neighbor is water, tree, or bridge terrain %
  :- construction(X, Y, door), not immediate_neighbors(X, Y, water, 0; X, Y, tree, 0; X, Y, bridge, 0).

  % CONSTRAINT #5: All pieces of the house (wall, door, floor, bed) may NOT be on water, bridges, or trees %
  :- terrain(X, Y, water; X, Y, bridge; X, Y, tree), construction(X, Y, wall; X, Y, door; X, Y, floor; X, Y, bed).

  % Walls must be adjacent to walls %
  :- construction(X, Y, wall),
     immediate_neighbors_construction(X, Y, wall, NUM_WALLS),
     immediate_neighbors_construction(X, Y, door, NUM_DOORS),
     NUM_WALLS + NUM_DOORS != 2.

  % Floors must be adjacent to floors or walls %
  :- construction(X, Y, floor), immediate_neighbors_construction(X, Y, floor, 0; X, Y, wall, 0).

  % Bed must be adjacent to floors %
  :- construction(X, Y, bed), immediate_neighbors_construction(X, Y, floor, 0).

  %NOTE 1 -- Right now it is possible for multiple constructions to be at the same location, 
  %          Make sure that each X and Y only has at most 1 construction
  :- construction(X, Y, wall), construction(X, Y, door; X, Y, floor; X, Y, bed).
  :- construction(X, Y, door), construction(X, Y, wall; X, Y, floor; X, Y, bed).
  :- construction(X, Y, floor), construction(X, Y, door; X, Y, wall; X, Y, bed).
  :- construction(X, Y, bed), construction(X, Y, door; X, Y, floor; X, Y, wall).

  %NOTE 2 -- You need to make sure that Beds and Floors are surrounded by other constructions
  :- construction(X, Y, floor), 
     immediate_neighbors_construction(X, Y, wall,  NUM_WALLS), 
     immediate_neighbors_construction(X, Y, door,  NUM_DOORS),
     immediate_neighbors_construction(X, Y, floor, NUM_FLOORS), 
     immediate_neighbors_construction(X, Y, bed,   NUM_BEDS),
     NUM_WALLS + NUM_DOORS + NUM_FLOORS + NUM_BEDS != 4.
